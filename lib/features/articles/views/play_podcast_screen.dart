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
import 'package:dio/dio.dart';
import 'package:atw_comm/core/service/textToSpeach.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/article_cubit.dart';
import '../logic/article_state.dart';

class PlayPodcastScreen extends StatefulWidget {
  final Podcast podcast;
  const PlayPodcastScreen({super.key, required this.podcast});

  @override
  State<PlayPodcastScreen> createState() => _PlayPodcastScreenState();
}

class _PlayPodcastScreenState extends State<PlayPodcastScreen> {
  final ElevenLabsService _ttsService =
      ElevenLabsService(apiKey: SharredKeys.elevenLabsKey);
  bool _isPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  String? _audioFilePath;

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
    _ttsService.audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _audioPosition = Duration.zero;
        _isPlaying = false;
      });
    });
    // Use cubit to prepare audio
    Future.microtask(
        () => context.read<ArticleCubit>().prepareAudio(widget.podcast));
  }

  @override
  void dispose() {
    _ttsService.stop(); // Stop any playing audio
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
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        bool showSlider = false;
        bool showStopOnly = false;
        if (state is AudioFileReady) {
          _audioFilePath = state.filePath;
          showSlider = true;
        } else if (state is TTSOnly) {
          _audioFilePath = null;
          showStopOnly = true;
        }
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 250.h,
                              child: Image.asset(Assets.figuresBoyHeadset,
                                  fit: BoxFit.contain),
                            ),
                            SizedBox(height: 8.h),
                            PublicText(
                              text: 'User Experience',
                              textTheme: TextStyles.font13DarkBlueMedium
                                  .copyWith(fontWeight: FontWeight.w500),
                              color: ColorsManager.darkBlue,
                              fontWeight: FontWeight.w500,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        // Title
                        PublicText(
                          text: widget.podcast.title,
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
                          text: 'by/ ${widget.podcast.authorName}',
                          textTheme: TextStyles.font12GrayRegular,
                          color: ColorsManager.gray,
                          fontWeight: FontWeight.normal,
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(height: 32.h),
                        // Audio controls
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: showSlider
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.replay_10,
                                          color: ColorsManager.mainColor,
                                          size: 28),
                                      onPressed: (_audioFilePath == null)
                                          ? null
                                          : _seekBackward,
                                    ),
                                    Container(
                                      width: 70.w,
                                      height: 70.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: ColorsManager.mainColor,
                                            width: 2),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          _isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: ColorsManager.mainColor,
                                          size: 40,
                                        ),
                                        onPressed: (_audioFilePath == null)
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
                                          color: ColorsManager.mainColor,
                                          size: 28),
                                      onPressed: (_audioFilePath == null)
                                          ? null
                                          : _seekForward,
                                    ),
                                  ],
                                )
                              : showStopOnly
                                  ? Center(
                                      child: Container(
                                        width: 70.w,
                                        height: 70.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: ColorsManager.mainColor,
                                              width: 2),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.stop,
                                              color: ColorsManager.mainColor,
                                              size: 40),
                                          onPressed: () {
                                            _ttsService.stop();
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                        ),
                        if (showSlider)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              children: [
                                Slider(
                                  value: _audioPosition.inMilliseconds
                                      .toDouble()
                                      .clamp(
                                          0,
                                          _audioDuration.inMilliseconds
                                              .toDouble()),
                                  min: 0.0,
                                  max: _audioDuration.inMilliseconds
                                              .toDouble() >
                                          0
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDuration(_audioPosition),
                                        style: TextStyle(
                                            color: ColorsManager.gray)),
                                    Text(_formatDuration(_audioDuration),
                                        style: TextStyle(
                                            color: ColorsManager.gray)),
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
      },
    );
  }
}
