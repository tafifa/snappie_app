import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NotificationButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool hasNotification;
  final Color? iconColor;
  final Color? badgeColor;
  final double? iconSize;
  final double? badgeSize;

  const NotificationButtonWidget({
    super.key,
    this.onPressed,
    this.hasNotification = false,
    this.iconColor,
    this.badgeColor,
    this.iconSize,
    this.badgeSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: iconColor ?? AppColors.textOnPrimary,
            size: iconSize ?? 24,
          ),
          if (hasNotification)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: badgeSize ?? 8,
                height: badgeSize ?? 8,
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
