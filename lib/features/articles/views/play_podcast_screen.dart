// ignore_for_file: unused_field

import 'package:atw_comm/core/service/textToSpeach.dart';
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
// Removed unused imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  bool _isImageUrl(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.svg');
  }

  String _fileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments.where((e) => e.isNotEmpty).toList();
      if (segments.isEmpty) return url;
      return segments.last;
    } catch (_) {
      return url;
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildAttachmentItem(String url) {
    final isImage = _isImageUrl(url);
    final border = Border.all(color: Colors.black12);
    final radius = BorderRadius.circular(12);
    return InkWell(
      onTap: () => _openUrl(url),
      child: Container(
        width: 110.w,
        height: 110.w,
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: ClipRRect(
          borderRadius: radius,
          child: isImage
              ? (url.toLowerCase().endsWith('.svg')
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.network(url, fit: BoxFit.contain),
                    )
                  : Image.network(url, fit: BoxFit.cover))
              : Container(
                  color: Colors.grey.shade50,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.insert_drive_file,
                          color: ColorsManager.mainColor),
                      const SizedBox(height: 8),
                      Text(
                        _fileNameFromUrl(url).split('/').isNotEmpty
                            ? _fileNameFromUrl(url).split('/').last
                            : 'File',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 11.sp, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
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
                          child:
                          Center(
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
                                            TextToSpeechService.stop();
                                          },
                                        ),
                                      ),
                                    )
                        ),
                        if (widget.podcast.attachments.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              children: [
                                Text(
                                  'Attachments',
                                  style: TextStyles.font18DarkBlueSemiBold
                                      .copyWith(color: ColorsManager.darkBlue),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            height: 120.w,
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.podcast.attachments.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) =>
                                  _buildAttachmentItem(
                                widget.podcast.attachments[index],
                              ),
                            ),
                          ),
                        ],
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
