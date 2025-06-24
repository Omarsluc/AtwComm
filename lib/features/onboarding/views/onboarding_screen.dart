import 'package:atw_comm/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theming/colors.dart';
import '../../../generated/assets.dart';
import 'landing_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation for elements
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation for some elements
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotationController);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorsManager.mainColor, // Purple
              ColorsManager.mainBlue, // Blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main Content Area with 3D Character and Floating Elements
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    // Floating Elements
                    AnimatedBuilder(
                      animation: _floatingAnimation,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            // Clock
                            Positioned(
                              top: 60.h + _floatingAnimation.value,
                              left: 40.w,
                              child: SizedBox(
                                  height: 80.h,
                                  width: 80.w,
                                  child: Image(image: AssetImage(Assets.figuresOnboardingStopwatch))),
                            ),

                            // Calculator/Grid
                            Positioned(
                              top: 100.h + _floatingAnimation.value * 0.7,
                              right: 60.w,
                              child: SizedBox(
                                  height: 60.h,
                                  width: 60.w,
                                  child: Image(image: AssetImage(Assets.figuresCalendar))),
                            ),

                            // Yellow Circle
                            Positioned(
                              top: 200.h + _floatingAnimation.value * 0.5,
                              left: 30.w,
                              child: SizedBox(
                                  height: 30.h,
                                  width: 30.w,
                                  child: Image(image: AssetImage(Assets.figuresOnboardingPieChart))),
                            ),

                            // Documents/Notes
                            Positioned(
                              top: 250.h + _floatingAnimation.value * 0.8,
                              right: 40.w,
                              child: SizedBox(
                                height: 80.h,
                                  width: 80.w,
                                  child: Image(image: AssetImage(Assets.figuresOnboardingTiles))),
                            ),

                            // Small decorative elements
                            Positioned(
                              top: 320.h + _floatingAnimation.value * 0.3,
                              left: 80.w,
                              child: Container(
                                width: 12.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 180.h + _floatingAnimation.value * 0.4,
                              right: 120.w,
                              child: Container(
                                width: 8.h,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    Center(
                      child: Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image(image: AssetImage(Assets.figuresFemaleOnboradingFigure))
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Section
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Logo/Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 30,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Title
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: 'Knowledge Starts '),
                              TextSpan(
                                text: 'Here',
                                style: TextStyle(
                                  color: ColorsManager.mainColor,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Subtitle
                        Text(
                          'Access insightful articles and start growing now.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const Spacer(),
                        // Get Started Button
                        AppButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LandingScreen()),
                          );
                        }, myText: 'Get Started', iconPath: '')
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}