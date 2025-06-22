import 'package:atw_comm/core/theming/colors.dart';
import 'package:flutter/material.dart';

class AnimatedFaceIdButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? icon;
  final double buttonSize;
  final int numberOfCircles;
  final Duration animationDuration;
  final List<Color> gradientColors;

  const AnimatedFaceIdButton({
    super.key,
    this.onTap,
    this.icon,
    this.buttonSize = 84.0, // 28 padding * 2 + icon size
    this.numberOfCircles = 3,
    this.animationDuration = const Duration(seconds: 2),
    this.gradientColors = const [ColorsManager.mainColor, Color(0xFF2B1E46)],
  });

  @override
  State<AnimatedFaceIdButton> createState() => _AnimatedFaceIdButtonState();
}

class _AnimatedFaceIdButtonState extends State<AnimatedFaceIdButton>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.numberOfCircles,
          (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 400), () {
        if (mounted) {
          _controllers[i].repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonSize * 2.0, // Extra space for circles
      height: widget.buttonSize * 2.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated circles
          ...List.generate(widget.numberOfCircles, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                final double scale = 1.0 + (_animations[index].value * (index + 1) * 0.5);
                final double opacity = 1.0 - _animations[index].value;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.buttonSize,
                    height: widget.buttonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.gradientColors[0].withOpacity(opacity * 0.3),
                        width: 2.0,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main Face ID button
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                gradient: LinearGradient(
                  begin: const Alignment(0.78, -0.19),
                  end: const Alignment(0.50, 1.00),
                  colors: widget.gradientColors,
                ),
              ),
              child: widget.icon ??
                  const Icon(
                    Icons.face,
                    color: Colors.white,
                    size: 28,
                  ), // Placeholder icon since SVG asset isn't available
            ),
          ),
        ],
      ),
    );
  }
}