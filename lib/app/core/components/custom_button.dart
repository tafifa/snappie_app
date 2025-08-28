import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;
  final bool isDisabled;
  final Duration animationDuration;
  final MainAxisSize mainAxisSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.iconSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.isLoading = false,
    this.isDisabled = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isDisabled 
        ? Colors.grey[300] 
        : backgroundColor ?? Colors.blue;
    
    final effectiveTextColor = isDisabled 
        ? Colors.grey[600] 
        : textColor ?? Colors.white;

    return GestureDetector(
      onTap: (isDisabled || isLoading) ? null : onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        padding: padding,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: borderColor != null 
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: effectiveTextColor,
                ),
              ),
              const SizedBox(width: 4),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: iconSize,
                color: effectiveTextColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
