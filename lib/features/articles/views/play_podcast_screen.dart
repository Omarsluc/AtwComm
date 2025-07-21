import 'dart:developer';

import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/theming/style.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:atw_comm/core/widgets/public_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/constants.dart';
import '../../../generated/assets.dart';
import 'package:atw_comm/core/service/elevenlabs_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PlayPodcastScreen extends StatefulWidget {
  const PlayPodcastScreen({super.key});

  @override
  State<PlayPodcastScreen> createState() => _PlayPodcastScreenState();
}

class _PlayPodcastScreenState extends State<PlayPodcastScreen> {
  final ElevenLabsService _ttsService =
      ElevenLabsService(apiKey: SharredKeys.elevenLabsKey);
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  String? _audioFilePath;

  String kmpPodcastScript = '''
🎙️ Welcome to DevTalk Bytes!

Today, we're diving into Kotlin Multiplatform (KMP) — a game-changer for mobile developers. KMP lets you share business logic across Android and iOS, using Kotlin for the core, while keeping native UI with Jetpack Compose and SwiftUI.

Imagine writing your networking, database, and state management once, and reusing it on both platforms — that's the KMP magic! It's perfect for teams that want efficiency without sacrificing native performance.

With growing tooling and community support, KMP is quickly becoming a top choice for modern cross-platform development.

🔊 Until next byte, keep coding smart!
''';
  final String _text = '''
🎙️ أهلاً بيك في DevTalk Bytes!

النهاردة هنتكلم عن Kotlin Multiplatform، وده فعلاً بيغير طريقة الشغل للمطورين. KMP بيسمحلك تكتب منطق التطبيق الأساسي (زي الاتصال بالسيرفر والداتا) مرة واحدة وتستخدمه على أندرويد وiOS، لكن الواجهات بتفضل نيتف زي Jetpack Compose وSwiftUI.

يعني بدل ما تكتب الكود مرتين، تكتبه مرة وتستفيد بيه في الجهتين — وده بيوفر وقت ومجهود كتير من غير ما تخسر أداء.

ومع التطوير اللي بيحصل في الأدوات والدعم، KMP بقت من أقوى الحلول للكروس-بلاتفورم.

🔊 لحد الحلقة الجاية، خليك دايمًا بتكود بذكاء!
''';
  final String _voiceId =
      'wxweiHvoC2r2jFM7mS8b'; // Egyptian Arabic voiceId from ElevenLabs

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
    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    setState(() => _isLoadingAudio = true);
    try {
      final audioBytes =
          await _ttsService.textToSpeech(text: _text, voiceId: _voiceId);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/preloaded_audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempFile.writeAsBytes(audioBytes);
      setState(() {
        _audioFilePath = tempFile.path;
      });
    } catch (e) {
      log(e.toString());
      // Optionally handle error
    }
    setState(() => _isLoadingAudio = false);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    // Category Card
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FFF6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60.h,
                            child: Image.asset(Assets.figuresOnboardingPieChart,
                                fit: BoxFit.contain),
                          ),
                          SizedBox(height: 8.h),
                          PublicText(
                            text: '3D Illustrations',
                            textTheme: TextStyles.font13DarkBlueMedium
                                .copyWith(fontWeight: FontWeight.w500),
                            color: ColorsManager.darkBlue,
                            fontWeight: FontWeight.w500,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Title
                    PublicText(
                      text: 'Kotlin Multiplatform ',
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
                      text: 'by/ Hager Ahmed',
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
