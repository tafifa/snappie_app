import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool enabled;
  final IconData? prefixIcon;
  final Color? iconColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  // final double? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool enableGlassmorphism;
  final double blurIntensity;
  final double backgroundOpacity;
  final double fontSize;
  final FontWeight? fontWeight;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.onTap,
    this.enabled = true,
    this.prefixIcon = Icons.search,
    this.iconColor,
    this.hintColor,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    // this.borderRadius = 25,
    this.margin,
    this.padding,
    this.enableGlassmorphism = false,
    this.blurIntensity = 10,
    this.backgroundOpacity = 0.3,
    this.fontSize = 14,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? 
        (enableGlassmorphism ? AppColors.textOnPrimary : AppColors.textSecondary);
    final effectiveHintColor = hintColor ?? 
        (enableGlassmorphism ? AppColors.textOnPrimary : AppColors.textSecondary);
    final effectiveTextColor = textColor ?? 
        (enableGlassmorphism ? AppColors.textOnPrimary : AppColors.textPrimary);
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surface;
    final effectiveBorderColor = borderColor ?? Colors.white.withOpacity(0.2);
    final effectiveMargin = margin ?? EdgeInsets.zero;
    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 16);
    final effectiveFontWeight = fontWeight ?? 
        (enableGlassmorphism ? FontWeight.bold : FontWeight.normal);

    Widget searchBarContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: enableGlassmorphism
            ? effectiveBackgroundColor.withOpacity(backgroundOpacity)
            : effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(36),
        border: enableGlassmorphism
            ? Border.all(
                color: effectiveBorderColor,
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: enableGlassmorphism 
                ? AppColors.shadowLight.withOpacity(0.1)
                : AppColors.shadowLight,
            spreadRadius: 1,
            blurRadius: enableGlassmorphism ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null)
            Icon(
              prefixIcon,
              color: effectiveIconColor,
              size: enableGlassmorphism ? 24 : 20,
            ),
          if (prefixIcon != null) const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              onTap: onTap,
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: fontSize,
                fontWeight: effectiveFontWeight,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: effectiveFontWeight,
                  color: effectiveHintColor,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );

    // Wrap with glassmorphism effect if enabled
    if (enableGlassmorphism) {
      searchBarContent = ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
          child: searchBarContent,
        ),
      );
    }

    return Container(
      margin: effectiveMargin,
      child: searchBarContent,
    );
  }
}
