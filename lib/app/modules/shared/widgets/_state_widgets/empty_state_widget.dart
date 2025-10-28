import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Main EmptyStateWidget with full customization support
class EmptyStateWidget extends StatelessWidget {
  final Widget? icon;
  final String? iconPath;
  final IconData? iconData;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? customAction;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final bool showAnimation;

  const EmptyStateWidget({
    super.key,
    this.icon,
    this.iconPath,
    this.iconData,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.customAction,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.spacing,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: padding ?? const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            SizedBox(height: spacing ?? 24),
            _buildTitle(),
            if (subtitle != null) ...[
              SizedBox(height: spacing != null ? spacing! / 2 : 12),
              _buildSubtitle(),
            ],
            if (actionText != null || customAction != null) ...[
              SizedBox(height: spacing ?? 24),
              _buildAction(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    Widget iconWidget;

    if (icon != null) {
      iconWidget = icon!;
    } else if (iconPath != null) {
      iconWidget = Image.asset(
        iconPath!,
        width: iconSize ?? 120,
        height: iconSize ?? 120,
        color: iconColor ?? AppColors.textTertiary,
      );
    } else {
      iconWidget = Icon(
        iconData ?? Icons.inbox_outlined,
        size: iconSize ?? 80,
        color: iconColor ?? AppColors.textTertiary,
      );
    }

    if (showAnimation) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(
              opacity: value,
              child: iconWidget,
            ),
          );
        },
      );
    }

    return iconWidget;
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: titleStyle ??
          TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle!,
      style: subtitleStyle ??
          TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAction() {
    if (customAction != null) {
      return customAction!;
    }

    return const SizedBox.shrink();
  }
}
