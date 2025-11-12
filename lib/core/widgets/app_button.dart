import 'package:atw_comm/core/theming/colors.dart';
import 'package:atw_comm/core/widgets/public_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theming/style.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.onPressed,
      required this.myText,
      this.isSecondary = false,
      this.isLoading = false,
      this.backGroundColor,
      this.textColor,
      this.width,
      this.radius = 18,
      this.textTheme,
      this.fontWeight = FontWeight.bold,
      // required this.fontSize,
      this.iconPath,
      this.borderSide,
      this.showIcon,
      this.height,
      this.padding})
      : super(key: key);

  final bool isSecondary;
  final Function()? onPressed;
  final String myText;
  final Color? backGroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double radius;
  final String? iconPath;
  final bool? showIcon;
  final TextStyle? textTheme;
  final FontWeight fontWeight;
  final EdgeInsets? padding;
  final BorderSide? borderSide;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: isSecondary
            ? OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFE8E1FF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: ColorsManager.mainColor),
                  borderRadius: BorderRadius.circular(radius),
                ))
            : ElevatedButton.styleFrom(
                backgroundColor: backGroundColor ?? ColorsManager.mainColor,
                disabledBackgroundColor:
                    (backGroundColor ?? ColorsManager.mainColor)
                        .withOpacity(0.6),
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                  side: borderSide ??
                      BorderSide(
                          width: 0,
                          color:
                              backGroundColor ?? ColorsManager.mainColor), // <-- Radius
                ),
              ),
        onPressed: isLoading ? null : onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: isLoading
                ? SizedBox(
                    height: 22.w,
                    width: 22.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isSecondary
                            ? ColorsManager.mainColor
                            : textColor ?? Colors.white,
                      ),
                    ),
                  )
                : Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PublicText(
                          text: myText,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          color: isSecondary
                              ? ColorsManager.mainColor
                              : textColor ?? Colors.white,
                          fontWeight: fontWeight,
                          textTheme: TextStyles.font14LightGrayRegular,
                          textOverflow: TextOverflow.ellipsis),
                      if (iconPath != null) ...[
                        SizedBox(width: 10.w),
                        SvgPicture.asset(iconPath!)
                      ],
                    ],
                  ),
          ),
        ),
        // margin: EdgeInsets.zero,
      ),
    );
  }
}