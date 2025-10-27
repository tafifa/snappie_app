import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool hasNotification;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;
  final double? badgeSize;

  const ButtonWidget({
    super.key,
    this.onPressed,
    this.hasNotification = false,
    this.icon,
    this.iconColor,
    this.backgroundColor = Colors.transparent,
    this.iconSize = 24,
    this.badgeSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: iconSize! + 8,
      height: iconSize! + 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.background,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: iconSize,
            ),
          ),
          if (hasNotification)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: iconSize! / 3,
                height: iconSize! / 3,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
