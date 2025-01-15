import 'package:flutter/material.dart';

class PublicText extends StatelessWidget {
  const PublicText(
      {Key? key,
      this.color,
      this.fontWeight = FontWeight.bold,
      this.textOverflow = TextOverflow.ellipsis,
      required this.text,
      this.textTheme,
      this.maxLines,
      this.padding = const EdgeInsets.symmetric(vertical: 5),
      this.textAlign = TextAlign.center,
      this.textDirection})
      : super(key: key);

  final Color? color;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String text;
  final TextDirection? textDirection;
  final EdgeInsets padding;
  final TextStyle? textTheme;
  final TextAlign textAlign;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(text,
          textAlign: textAlign,
          textScaleFactor: 1.0,
          maxLines: maxLines ?? 100,
          overflow: textOverflow,
          style: textTheme?.copyWith(
              color: color ?? Colors.black,
              fontWeight: fontWeight,
              fontFamily: 'Almarai')),
    );
  }
}
