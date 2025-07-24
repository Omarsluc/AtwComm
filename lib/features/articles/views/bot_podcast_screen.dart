import 'dart:developer';

import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:atw_comm/core/widgets/public_text.dart';
import 'package:atw_comm/features/articles/model/podcast_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/constants.dart';
import '../../../generated/assets.dart';
import 'package:atw_comm/core/service/elevenlabs_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:atw_comm/core/service/textToSpeach.dart';
import 'package:dio/dio.dart';

class PlayBotPodcastScreen extends StatefulWidget {
  final String podcastText;
  const PlayBotPodcastScreen({super.key, required this.podcastText});

  @override
  State<PlayBotPodcastScreen> createState() => _PlayBotPodcastScreenState();
}

class _PlayBotPodcastScreenState extends State<PlayBotPodcastScreen> {
  final ElevenLabsService _ttsService =
      ElevenLabsService(apiKey: SharredKeys.elevenLabsKey);
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  String? _audioFilePath;

  final String _voiceId =
      's3TPKV1kjDlVtZbl4Ksh'; // Egyptian Arabic voiceId from ElevenLabs

  @override
  void initState() {
    super.initState();
    _ttsService.audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });
    _ttsService.audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _audioPosition = position;
      });
    });
    _ttsService.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
        _isPlaying = state == PlayerState.playing;
      });
    });
    // Add listener to reset position when playback completes
    _ttsService.audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _audioPosition = Duration.zero;
        _isPlaying = false;
      });
    });
    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    setState(() => _isLoadingAudio = true);
    log(widget.podcastText);
    try {
      final audioBytes = await _ttsService.textToSpeech(
          text: widget.podcastText, voiceId: _voiceId);
      if (audioBytes == null || audioBytes.isEmpty) {
        throw Exception('Audio bytes are empty');
      }
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/preloaded_audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempFile.writeAsBytes(audioBytes);
      setState(() {
        _audioFilePath = tempFile.path;
        _isLoadingAudio = false;
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        log('Received 401 from ElevenLabs, falling back to FlutterTTS');
        await TextToSpeechService.speak(text: widget.podcastText);
        setState(() {
          _audioFilePath = null; // disables the play button/slider
          _isLoadingAudio = false;
        });
        return;
      }
      log('ElevenLabs DioException, falling back to FlutterTTS: $e');
      await TextToSpeechService.speak(text: widget.podcastText);
      setState(() {
        _audioFilePath = null;
        _isLoadingAudio = false;
      });
    } catch (e) {
      log('ElevenLabs failed, falling back to FlutterTTS: $e');
      await TextToSpeechService.speak(text: widget.podcastText);
      setState(() {
        _audioFilePath = null;
        _isLoadingAudio = false;
      });
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  Future<void> _playTTS() async {
    if (_audioFilePath == null) return;
    if (_audioPosition >= _audioDuration && _audioDuration > Duration.zero) {
      await _ttsService.audioPlayer.seek(Duration.zero);
    }
    if (!_isPlaying) {
      try {
        await _ttsService.audioPlayer.play(DeviceFileSource(_audioFilePath!));
      } catch (e) {}
    } else {
      await _ttsService.pause();
    }
  }

  Future<void> _resumeTTS() async {
    await _ttsService.resume();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _seekBackward() async {
    final newPosition = _audioPosition - const Duration(seconds: 10);
    await _ttsService.audioPlayer
        .seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> _seekForward() async {
    final newPosition = _audioPosition + const Duration(seconds: 10);
    await _ttsService.audioPlayer
        .seek(newPosition > _audioDuration ? _audioDuration : newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 24.h),
                    // Category Card
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FFF6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 300.h,
                            width: 300.w,
                            child: Image.asset(Assets.figuresBot,
                                fit: BoxFit.contain),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Title
                    PublicText(
                      text: 'Ai Podcast',
                      textTheme: TextStyles.font24BlueBold.copyWith(
                        color: ColorsManager.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                      ),
                      color: ColorsManager.mainColor,
                      fontWeight: FontWeight.bold,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 4.h),
                    PublicText(
                      text: 'by/ your favourite bot',
                      textTheme: TextStyles.font12GrayRegular,
                      color: ColorsManager.gray,
                      fontWeight: FontWeight.normal,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 32.h),
                    // Audio controls
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.replay_10,
                                color: ColorsManager.mainColor, size: 28),
                            onPressed:
                                (_audioFilePath == null || _isLoadingAudio)
                                    ? null
                                    : _seekBackward,
                          ),
                          Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: ColorsManager.mainColor, width: 2),
                            ),
                            child: _isLoadingAudio
                                ? Center(
                                    child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                            color: ColorsManager.mainColor,
                                            strokeWidth: 3)))
                                : IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: ColorsManager.mainColor,
                                      size: 40,
                                    ),
                                    onPressed: (_audioFilePath == null ||
                                            _isLoadingAudio)
                                        ? null
                                        : () {
                                            if (_isPlaying) {
                                              _ttsService.pause();
                                            } else if (_audioPosition >
                                                    Duration.zero &&
                                                _audioPosition <
                                                    _audioDuration) {
                                              _resumeTTS();
                                            } else {
                                              _playTTS();
                                            }
                                          },
                                  ),
                          ),
                          IconButton(
                            icon: Icon(Icons.forward_10,
                                color: ColorsManager.mainColor, size: 28),
                            onPressed:
                                (_audioFilePath == null || _isLoadingAudio)
                                    ? null
                                    : _seekForward,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Progress bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          Slider(
                            value: _audioPosition.inMilliseconds
                                .toDouble()
                                .clamp(0,
                                    _audioDuration.inMilliseconds.toDouble()),
                            min: 0.0,
                            max: _audioDuration.inMilliseconds.toDouble() > 0
                                ? _audioDuration.inMilliseconds.toDouble()
                                : 1.0,
                            onChanged: (value) async {
                              final seekTo =
                                  Duration(milliseconds: value.toInt());
                              await _ttsService.audioPlayer.seek(seekTo);
                            },
                            activeColor: ColorsManager.mainColor,
                            inactiveColor: Colors.black12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(_audioPosition),
                                  style: TextStyle(color: ColorsManager.gray)),
                              Text(_formatDuration(_audioDuration),
                                  style: TextStyle(color: ColorsManager.gray)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
