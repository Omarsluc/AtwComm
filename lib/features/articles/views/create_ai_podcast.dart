import 'dart:developer';

import 'package:atw_comm/features/articles/views/bot_podcast_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/theming/colors.dart';
import '../../../core/theming/style.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/Api/supabaseApi.dart';
import '../../../core/service/elevenlabs_service.dart';
import '../../../core/helpers/constants.dart';
import 'dart:typed_data';

class CreateAIPodcastScreen extends StatefulWidget {
  const CreateAIPodcastScreen({super.key});

  @override
  State<CreateAIPodcastScreen> createState() => _CreateAIPodcastScreenState();
}

class _CreateAIPodcastScreenState extends State<CreateAIPodcastScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isReady = false;
  String? _userAnswer;
  final Dio _dio = Dio();
  String? _validationError;

  // Validation method
  String? _validateInput(String input) {
    // Check if input is empty or only whitespace
    if (input.trim().isEmpty) {
      return 'Please enter a topic for your podcast';
    }

    // Check if input contains Arabic characters
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    if (arabicRegex.hasMatch(input)) {
      return 'Please enter your topic in English only';
    }

    // Check minimum length (optional - you can adjust or remove this)
    if (input.trim().length < 3) {
      return 'Topic must be at least 3 characters long';
    }

    // Check maximum length (optional - you can adjust or remove this)
    if (input.trim().length > 200) {
      return 'Topic must be less than 200 characters';
    }

    return null; // No validation errors
  }

  void _submitAnswer() async {
    final input = _controller.text.trim();

    // Validate input
    final validationError = _validateInput(input);
    if (validationError != null) {
      setState(() {
        _validationError = validationError;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Clear any previous validation errors
    setState(() {
      _validationError = null;
      _userAnswer = input;
      _isLoading = true;
    });

    _generatePodcast();
  }

  Future<void> _generatePodcast() async {
    try {
      final response = await _dio.post(
        'https://ml-test.atwdemo.com/generate-podcast',
        data: {'topic': _userAnswer},
        options: Options(
          receiveTimeout: const Duration(minutes: 5), // Set timeout
        ),
      );

      if (response.statusCode == 200) {
        final conversation = response.data['conversation'];
        final podcastText = conversation is List
            ? conversation.join('\n\n')
            : (conversation ?? '');

        // --- AI Podcast DB and Storage Integration ---
        final title = _userAnswer ?? 'AI Podcast';
        // 1. Create podcast entry in DB (without audio_url)
        final podcast = await createAiPodcast(
          title: title,
          article: podcastText,
        );
        if (podcast == null) {
          throw Exception('Failed to create podcast');
        }
        setState(() {
          _isLoading = false;
          _isReady = true;
        });

        // Wait for the state to update before navigating
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PlayBotPodcastScreen(
                podcastText: podcastText,
              ),
            ),
          );
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate podcast')),
        );
      }
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('An error occurred: $e\nResponse data: ${e.response?.data}');
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.response?.data}')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('$e error occurred');
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      appBar: AppBar(
        backgroundColor: ColorsManager.mainColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                child: ListView(
                  children: [
                    const _SystemBubble(text: 'Hello There!'),
                    SizedBox(height: 16.h),
                    const _SystemBubble(
                      text:
                      "What topic are you interested in? Tell us what you'd like to hear about (in English only).",
                    ),
                    SizedBox(height: 16.h),
                    if (_userAnswer != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _UserBubble(text: _userAnswer!),
                      ),
                    if (_userAnswer != null) SizedBox(height: 16.h),
                    if (_isLoading || _isReady)
                      const _SystemBubble(
                        isLoading: true,
                        text:
                        "We're finding the best episode for you... Hang tight!",
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (!_isLoading && !_isReady)
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type your topic',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _validationError != null
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _validationError != null
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _validationError != null
                                      ? Colors.red
                                      : ColorsManager.mainColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 10.h),
                            ),
                            onSubmitted: (_) => _submitAnswer(),
                            onChanged: (value) {
                              // Clear validation error when user starts typing
                              if (_validationError != null) {
                                setState(() {
                                  _validationError = null;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        IconButton(
                          icon: const Icon(Icons.send,
                              color: ColorsManager.mainColor),
                          onPressed: _submitAnswer,
                        ),
                      ],
                    ),
                    // Show validation error below the text field
                    if (_validationError != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _validationError!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: ColorsManager.mainColor, strokeWidth: 2.5),
                  ),
                  SizedBox(width: 12),
                  Text('Finding your podcast...',
                      style: TextStyle(color: ColorsManager.mainColor)),
                ],
              ),
            ),
          if (_isReady)
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: AppButton(
                  myText: 'Your Podcast is ready!',
                  onPressed: () {
                    // This button is now primarily for show,
                    // since navigation happens automatically.
                    // You could keep it for retry logic or other actions.
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SystemBubble extends StatelessWidget {
  final String text;
  final bool isLoading;
  const _SystemBubble({required this.text, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsManager.mainColor, width: 1.5),
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
        ),
        child: isLoading ? Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                color: ColorsManager.mainColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 74.w,
                height: 24.h,
                child: SpinKitThreeBounce(
                  size: 30.sp,
                  color: Colors.grey,),)
          ],
        ) : Text(
          text,
          style: TextStyle(
            color: ColorsManager.mainColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorsManager.mainColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}