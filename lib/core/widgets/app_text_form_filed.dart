import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_borders/gradient_borders.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final Gradient? gradientBorder;
  final double? borderWidth;
  final double? borderRadius;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool? isEnabled;

  const AppTextFormField({
    Key? key,
    required this.hintText,
    this.isEnabled,
    this.obscureText,
    this.contentPadding,
    this.hintStyle,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.gradientBorder,
    this.borderWidth,
    this.borderRadius,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled ?? true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        hintText: hintText,
        hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: backgroundColor ?? const Color(0x6600804C),
        filled: true,
        enabledBorder: GradientOutlineInputBorder(
          gradient: gradientBorder ??
              const LinearGradient(colors: [Colors.blue, Colors.green]),
          width: borderWidth ?? 2.0,
          borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        ),
        disabledBorder: GradientOutlineInputBorder(
          gradient: gradientBorder ??
              const LinearGradient(colors: [Colors.blue, Colors.green]),
          width: borderWidth ?? 2.0,
          borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        ),
        focusedBorder: GradientOutlineInputBorder(
          gradient: gradientBorder ??
              const LinearGradient(colors: [Colors.blue, Colors.green]),
          width: borderWidth ?? 2.0,
          borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        ),
        errorBorder: GradientOutlineInputBorder(
          gradient:
              const LinearGradient(colors: [Colors.red, Colors.redAccent]),
          width: borderWidth ?? 2.0,
          borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        ),
        focusedErrorBorder: GradientOutlineInputBorder(
          gradient:
              const LinearGradient(colors: [Colors.red, Colors.redAccent]),
          width: borderWidth ?? 2.0,
          borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        ),
      ),
    );
  }
}
