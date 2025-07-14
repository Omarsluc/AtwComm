import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../generated/assets.dart';
import '../theming/colors.dart';
import 'custom_appbar.dart';

class GlobeAppbarWidget extends StatelessWidget {
  const GlobeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.none,
      child: Container(
        height: 300.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsManager.mainColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            //background bubble like figure
            Positioned(top: 5.h,right: -0.h,child: SvgPicture.asset(Assets.figuresBackgroundBubble)),
            // Back button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Globe image
            Positioned(
              right: 0,
              top: 20.h,
              child: Image.asset(
                Assets.figuresWorldGlobeBooks,
                height: 280.h,
              ),
            ),
          ],
        ),
      ),
    );
 }
}
