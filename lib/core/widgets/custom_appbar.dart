import 'package:atw_comm/core/theming/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color textColor;
  final double elevation;
  final Color backGroundColor;

  const CustomAppBar({
    super.key,
    this.title = 'Back',
    this.onBackPressed,
    this.showBackButton = true,
    this.textColor = Colors.white,
    this.elevation = 0,
    this.backGroundColor = ColorsManager.mainColor
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorsManager.mainColor,
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(24),
        //   bottomRight: Radius.circular(24),
        // ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: textColor,
                        size: 28,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}