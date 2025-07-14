import 'package:atw_comm/core/helpers/extention.dart';
import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/app_button.dart';
import 'package:atw_comm/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/routing/routes.dart';
import '../../../core/widgets/animating_faceID_button.dart';
import '../../../generated/assets.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      appBar: CustomAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40)
          )
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi there!",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "You can find articles here",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      Text(
                        "Ready to learn? Browse articles and discover ideas that spark your curiosity.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 24.h),
                      Image.asset(
                        Assets.figuresGuyTextingLanding, // Replace with your asset path
                        height: 180.h,
                      ),
                      AppButton(onPressed: () => context.pushNamed(Routes.articlesCategoriesScreen), myText: 'Find Articles', iconPath: Assets.iconsArrowRight),
                      SizedBox(height: 20.h),
                      Text(
                        "Staff Member?",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "sign in to continue",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 40.h),
                      AnimatedFaceIdButton(
                        icon: SvgPicture.asset(Assets.iconsFaceID),
                        onTap: () => context.pushNamed(Routes.cameraScreen),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
