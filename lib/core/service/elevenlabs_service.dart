import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class ElevenLabsService {
  static const String _baseUrl = 'https://api.elevenlabs.io/v1';
  final String _apiKey;
  final Dio _dio;
  final AudioPlayer audioPlayer = AudioPlayer();

  ElevenLabsService({required String apiKey})
      : _apiKey = apiKey,
        _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Accept': 'application/json',
      'xi-api-key': _apiKey,
    };
  }

  /// Get available voices from ElevenLabs
  Future<List<Voice>> getVoices() async {
    try {
      final response = await _dio.get('/voices');

      final List<Voice> voices = [];
      for (var voiceData in response.data['voices']) {
        voices.add(Voice.fromJson(voiceData));
      }

      return voices;
    } on DioException catch (e) {
      throw Exception('Failed to fetch voices: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching voices: $e');
    }
  }

  /// Convert text to speech and return audio bytes
  Future<Uint8List> textToSpeech({
    required String text,
    required String voiceId,
    double stability = 0.5,
    double similarityBoost = 0.5,
    String modelId = 'eleven_multilingual_v2',
  }) async {
    try {
      final response = await _dio.post(
        '/text-to-speech/$voiceId',
        data: {
          'text': text,
          'model_id': modelId,
          'voice_settings': {
            'stability': stability,
            'similarity_boost': similarityBoost,
          },
        },
        options: Options(
          headers: {
            'Accept': 'audio/mpeg',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.bytes,
        ),
      );

      return Uint8List.fromList(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to generate speech: ${e.message}');
    } catch (e) {
      throw Exception('Error generating speech: $e');
    }
  }

  /// Convert text to speech and play directly
  Future<void> speak({
    required String text,
    required String voiceId,
    double stability = 0.5,
    double similarityBoost = 0.5,
    String modelId = 'eleven_monolingual_v1',
  }) async {
    try {
      final audioBytes = await textToSpeech(
        text: text,
        voiceId: voiceId,
        stability: stability,
        similarityBoost: similarityBoost,
        modelId: modelId,
      );

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempFile.writeAsBytes(audioBytes);

      // Play the audio
      await audioPlayer.play(DeviceFileSource(tempFile.path));

      // Clean up temp file after playing
      audioPlayer.onPlayerComplete.listen((_) {
        tempFile.deleteSync();
      });
    } catch (e) {
      throw Exception('Error playing speech: $e');
    }
  }

  /// Stream text to speech (for longer texts)
  Future<void> streamTextToSpeech({
    required String text,
    required String voiceId,
    double stability = 0.5,
    double similarityBoost = 0.5,
    String modelId = 'eleven_monolingual_v1',
    bool optimizeStreamingLatency = true,
  }) async {
    try {
      final response = await _dio.post(
        '/text-to-speech/$voiceId/stream',
        data: {
          'text': text,
          'model_id': modelId,
          'voice_settings': {
            'stability': stability,
            'similarity_boost': similarityBoost,
          },
          'optimize_streaming_latency': optimizeStreamingLatency,
        },
        options: Options(
          headers: {
            'Accept': 'audio/mpeg',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
      );

      // Save streamed data to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/stream_audio_${DateTime.now().millisecondsSinceEpoch}.mp3');

      final sink = tempFile.openWrite();
      await response.data.stream.forEach((chunk) {
        sink.add(chunk);
      });
      await sink.close();

      // Play the streamed audio
      await audioPlayer.play(DeviceFileSource(tempFile.path));

      // Clean up temp file after playing
      audioPlayer.onPlayerComplete.listen((_) {
        tempFile.deleteSync();
      });
    } on DioException catch (e) {
      throw Exception('Failed to stream speech: ${e.message}');
    } catch (e) {
      throw Exception('Error streaming speech: $e');
    }
  }

  /// Stop current playback
  Future<void> stop() async {
    await audioPlayer.stop();
  }

  /// Pause current playback
  Future<void> pause() async {
    await audioPlayer.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await audioPlayer.resume();
  }

  /// Get current playback state
  PlayerState get playerState => audioPlayer.state;

  /// Dispose resources
  void dispose() {
    audioPlayer.dispose();
    _dio.close();
  }
}

class Voice {
  final String voiceId;
  final String name;
  final String category;
  final String description;
  final Map<String, dynamic> settings;

  Voice({
    required this.voiceId,
    required this.name,
    required this.category,
    required this.description,
    required this.settings,
  });

  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(
      voiceId: json['voice_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      settings: json['settings'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voice_id': voiceId,
      'name': name,
      'category': category,
      'description': description,
      'settings': settings,
    };
  }

  @override
  String toString() {
    return 'Voice(name: $name, category: $category)';
  }
}

// Usage Example:
/*
class TTSExample extends StatefulWidget {
  @override
  _TTSExampleState createState() => _TTSExampleState();
}

class _TTSExampleState extends State<TTSExample> {
  late ElevenLabsService _ttsService;
  List<Voice> _voices = [];
  String? _selectedVoiceId;

  @override
  void initState() {
    super.initState();
    _ttsService = ElevenLabsService(apiKey: 'your_api_key_here');
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    try {
      final voices = await _ttsService.getVoices();
      setState(() {
        _voices = voices;
        if (voices.isNotEmpty) {
          _selectedVoiceId = voices.first.voiceId;
        }
      });
    } catch (e) {
      print('Error loading voices: $e');
    }
  }

  Future<void> _speak(String text) async {
    if (_selectedVoiceId != null) {
      try {
        await _ttsService.speak(
          text: text,
          voiceId: _selectedVoiceId!,
        );
      } catch (e) {
        print('Error speaking: $e');
      }
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}
*/