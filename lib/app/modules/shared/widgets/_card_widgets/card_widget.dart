import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum CardType {
  elevated,
  outlined,
  filled,
}

class CardWidget extends StatelessWidget {
  final Widget child;
  final CardType type;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final Color? selectedColor;
  final Gradient? gradient;
  final List<BoxShadow>? customShadows;
  final Clip clipBehavior;

  const CardWidget({
    super.key,
    required this.child,
    this.type = CardType.elevated,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.selectedColor,
    this.gradient,
    this.customShadows,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isSelected
        ? (selectedColor ?? AppColors.primary.withOpacity(0.1))
        : backgroundColor;

    Widget card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: _buildDecoration(effectiveBackgroundColor),
      clipBehavior: clipBehavior,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null || onLongPress != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: card,
        ),
      );
    }

    return card;
  }

  BoxDecoration _buildDecoration(Color? effectiveBackgroundColor) {
    switch (type) {
      case CardType.elevated:
        return BoxDecoration(
          color: effectiveBackgroundColor ?? AppColors.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          gradient: gradient,
          boxShadow: customShadows ?? [
            BoxShadow(
              color: shadowColor ?? AppColors.shadowLight,
              blurRadius: elevation ?? 4,
              offset: Offset(0, (elevation ?? 4) / 2),
              spreadRadius: 0,
            ),
          ],
        );
      
      case CardType.outlined:
        return BoxDecoration(
          color: effectiveBackgroundColor ?? AppColors.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          gradient: gradient,
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppColors.primary)
                : (borderColor ?? AppColors.border.withOpacity(0.2)),
            width: borderWidth ?? (isSelected ? 2 : 1),
          ),
        );
      
      case CardType.filled:
        return BoxDecoration(
          color: effectiveBackgroundColor ?? AppColors.surfaceContainer,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          gradient: gradient,
        );
    }
  }
}

// Specialized card widgets for common use cases
class InfoCardWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const InfoCardWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Row(
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: iconColor ?? AppColors.primary,
                size: 24,
              ),
              child: icon!,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: subtitleStyle ??
                        TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? valueColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.valueColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (icon != null)
                IconTheme(
                  data: IconThemeData(
                    color: iconColor ?? AppColors.primary,
                    size: 20,
                  ),
                  child: icon!,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
