import 'package:flutter/material.dart';

class GradientCircleAvatar extends StatelessWidget {
  final String text;
  final double radius;
  final Gradient gradient;

  const GradientCircleAvatar({
    Key? key,
    required this.text,
    this.radius = 50.0,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration:
      BoxDecoration(shape: BoxShape.circle, gradient: gradient, boxShadow: [
        BoxShadow(
          color: Colors.green.withOpacity(0.5),
          blurRadius: 10.0,
          offset: Offset(-15, 10), // Shadow position
        ),
      ]),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius / 4, // Adjust font size based on radius
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}