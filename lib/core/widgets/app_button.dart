import 'package:atw_comm/core/widgets/public_text.dart';
import 'package:flutter/material.dart';

import '../theming/style.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.onPressed,
      required this.myText,
      required this.backGroundColor,
      this.textColor,
      this.width,
      this.radius = 12,
      this.textTheme,
      this.fontWeight = FontWeight.bold,
      // required this.fontSize,
      required this.iconPath,
      this.borderSide,
      this.showIcon,
      this.height,
      this.padding})
      : super(key: key);

  final Function()? onPressed;
  final String myText;
  final Color backGroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double radius;
  final String iconPath;
  final bool? showIcon;
  final TextStyle? textTheme;
  final FontWeight fontWeight;
  final EdgeInsets? padding;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backGroundColor,
          foregroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: borderSide ??
                BorderSide(width: 0, color: backGroundColor), // <-- Radius
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PublicText(
                text: myText,
                textAlign: TextAlign.center,
                maxLines: 1,
                color: textColor ?? Colors.white,
                fontWeight: fontWeight,
                textTheme: TextStyles.font14LightGrayRegular,
                textOverflow: TextOverflow.ellipsis),
          ),
        ),
        // margin: EdgeInsets.zero,
        // borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
