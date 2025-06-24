import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import '../../../core/service/elevenlabs_service.dart';
import 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final ElevenLabsService _ttsService;

  // Private state variables
  List<Voice> _voices = [];
  Voice? _selectedVoice;
  String? _currentText;
  String? _errorMessage;
  PlayerState _playerState = PlayerState.stopped;

  ArticleCubit({required ElevenLabsService ttsService})
      : _ttsService = ttsService,
        super(ArticleInitialState()) {
    _setupPlayerStateListener();
  }

  // Getters to access state data
  List<Voice> get voices => _voices;
  Voice? get selectedVoice => _selectedVoice;
  String? get currentText => _currentText;
  String? get errorMessage => _errorMessage;
  PlayerState get playerState => _playerState;

  void _setupPlayerStateListener() {
    _ttsService.audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _playerState = state;
      if (_currentText != null) {
        switch (state) {
          case PlayerState.playing:
            emit(TTSPlaying());
            break;
          case PlayerState.paused:
            emit(TTSPaused());
            break;
          case PlayerState.stopped:
          case PlayerState.completed:
            _currentText = null;
            emit(TTSStopped());
            break;
          case PlayerState.disposed:
            emit(TTSInitial());
            break;
        }
      }
    });
  }

  // Load available voices
  Future<void> loadVoices() async {
    try {
      emit(TTSLoading());
      _voices = await _ttsService.getVoices();
      _selectedVoice = _voices.isNotEmpty ? _voices.first : null;
      _errorMessage = null;
      emit(TTSVoicesLoaded());
    } catch (e) {
      _errorMessage = 'Failed to load voices: ${e.toString()}';
      emit(TTSError());
    }
  }

  // // Select a voice
  // void selectVoice(Voice voice) {
  //   _selectedVoice = voice;
  //   if (state is TTSVoicesLoaded) {
  //     emit(TTSVoicesLoaded());
  //   }
  // }

  // Speak text
  Future<void> speak({
    required String text,
    Voice? voice,
    double stability = 0.5,
    double similarityBoost = 0.5,
    String modelId = 'eleven_monolingual_v1',
  }) async {
    final voiceToUse = voice ?? _selectedVoice;

    if (voiceToUse == null) {
      _errorMessage = 'No voice selected';
      emit(TTSError());
      return;
    }

    try {
      _currentText = text;
      _errorMessage = null;
      emit(TTSSpeaking());

      await _ttsService.speak(
        text: text,
        voiceId: voiceToUse.voiceId,
        stability: stability,
        similarityBoost: similarityBoost,
        modelId: modelId,
      );
    } catch (e) {
      _errorMessage = 'Failed to speak: ${e.toString()}';
      _currentText = null;
      emit(TTSError());
    }
  }

  // Stream text to speech (for longer texts)
  Future<void> streamSpeak({
    required String text,
    Voice? voice,
    double stability = 0.5,
    double similarityBoost = 0.5,
    String modelId = 'eleven_monolingual_v1',
    int optimizeStreamingLatency = 0,
  }) async {
    final voiceToUse = voice ?? _selectedVoice;

    if (voiceToUse == null) {
      _errorMessage = 'No voice selected';
      emit(TTSError());
      return;
    }

    try {
      _currentText = text;
      _errorMessage = null;
      emit(TTSSpeaking());

      await _ttsService.streamTextToSpeech(
        text: text,
        voiceId: voiceToUse.voiceId,
        stability: stability,
        similarityBoost: similarityBoost,
        modelId: modelId,
      );
    } catch (e) {
      _errorMessage = 'Failed to stream speak: ${e.toString()}';
      _currentText = null;
      emit(TTSError());
    }
  }

  // Pause playback
  Future<void> pause() async {
    try {
      await _ttsService.pause();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to pause: ${e.toString()}';
      emit(TTSError());
    }
  }

  // Resume playback
  Future<void> resume() async {
    try {
      await _ttsService.resume();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to resume: ${e.toString()}';
      emit(TTSError());
    }
  }

  // Stop playback
  Future<void> stop() async {
    try {
      await _ttsService.stop();
      _currentText = null;
      _errorMessage = null;
      emit(TTSStopped());
    } catch (e) {
      _errorMessage = 'Failed to stop: ${e.toString()}';
      emit(TTSError());
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_voices.isNotEmpty) {
      emit(TTSVoicesLoaded());
    } else {
      emit(TTSInitial());
    }
  }

  @override
  Future<void> close() {
    _ttsService.dispose();
    return super.close();
  }
}