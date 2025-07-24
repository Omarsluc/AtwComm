import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/service/elevenlabs_service.dart';
import '../../../core/service/textToSpeach.dart';
import 'article_state.dart';
import '../model/podcast_model.dart';

class ArticleCubit extends Cubit<ArticleState> {

  // Private state variables
  List<Voice> _voices = [];
  Voice? _selectedVoice;
  String? _currentText;
  String? _errorMessage;
  PlayerState _playerState = PlayerState.stopped;

  ArticleCubit() :
        super(ArticleInitialState()) {
  }

  // Getters to access state data
  List<Voice> get voices => _voices;
  Voice? get selectedVoice => _selectedVoice;
  String? get currentText => _currentText;
  String? get errorMessage => _errorMessage;
  PlayerState get playerState => _playerState;



  Future<void> prepareAudio(Podcast podcast) async {
    emit(TTSLoading());
    final audioUrl = podcast.audioUrl;
    if (audioUrl != null && audioUrl.isNotEmpty) {
      try {
        log('Trying to download audio from: $audioUrl');
        final tempDir = await getTemporaryDirectory();
        final tempFile =
            File('${tempDir.path}/podcast_audio_${podcast.id}.mp3');
        final response = await Dio().get(
          audioUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        await tempFile.writeAsBytes(response.data);
        emit(AudioFileReady(tempFile.path));
        return;
      } on DioException catch (e) {
        log('Failed to download audio from Supabase: $e');
        if (e.response?.statusCode == 400) {
          // Optionally handle error
        }
        await TextToSpeechService.speak(text: podcast.article);
        emit(TTSOnly());
        return;
      } catch (e) {
        log('Failed to download audio from Supabase: $e');
        await TextToSpeechService.speak(text: podcast.article);
        emit(TTSOnly());
        return;
      }
    }
    // Fallback: Use Flutter TTS only (not ElevenLabs)
    await TextToSpeechService.speak(text: podcast.article);
    emit(TTSOnly());
  }

}
