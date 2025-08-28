import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.padding,
    this.margin,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (selectedColor ?? AppColors.primary)
                : (unselectedColor ?? AppColors.surface),
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? (selectedColor ?? AppColors.primary)
                  : AppColors.border.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? (selectedTextColor ?? AppColors.textOnPrimary)
                  : (unselectedTextColor ?? AppColors.textSecondary),
              fontSize: fontSize ?? 12,
              fontWeight: fontWeight ?? FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
