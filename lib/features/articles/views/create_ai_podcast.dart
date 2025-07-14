import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/style.dart';
import '../../../core/widgets/app_button.dart';

class CreateAIPodcastScreen extends StatefulWidget {
  const CreateAIPodcastScreen({Key? key}) : super(key: key);

  @override
  State<CreateAIPodcastScreen> createState() => _CreateAIPodcastScreenState();
}

class _CreateAIPodcastScreenState extends State<CreateAIPodcastScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isReady = false;
  String? _userAnswer;

  void _submitAnswer() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _userAnswer = _controller.text.trim();
      _isLoading = true;
    });
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _isReady = true;
    });
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
                    _SystemBubble(text: 'Hello There!'),
                    SizedBox(height: 16.h),
                    _SystemBubble(
                      text:
                          "What topic are you interested in? Tell us what you'd like to hear about.",
                    ),
                    SizedBox(height: 16.h),
                    if (_userAnswer != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _UserBubble(text: _userAnswer!),
                      ),
                    if (_userAnswer != null) SizedBox(height: 16.h),
                    if (_isLoading || _isReady)
                      _SystemBubble(
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type your answer...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                        ),
                        onSubmitted: (_) => _submitAnswer(),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      icon: Icon(Icons.send, color: ColorsManager.mainColor),
                      onPressed: _submitAnswer,
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              child: Row(
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
                    // TODO: Add navigation or action
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
  const _SystemBubble({required this.text});

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
        child: Text(
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
