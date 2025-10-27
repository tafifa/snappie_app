import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/constants/app_colors.dart';

/// Reusable scaffold layout with AppBar and content wrapper
/// 
/// Usage:
/// ```dart
/// DetailLayout(
///   title: 'Page Title',
///   body: YourWidget(),
/// )
/// ```
class DetailLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final bool useContainerWrapper;
  final EdgeInsets? bodyPadding;

  const DetailLayout({
    super.key,
    required this.title,
    required this.body,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.useContainerWrapper = true,
    this.bodyPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: appBarBackgroundColor ?? AppColors.background,
        surfaceTintColor: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.shadowDark,
        leading: showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                ),
                onPressed: onBackPressed ?? () => Get.back(),
              )
            : null,
        actions: actions,
      ),
      body: SafeArea(
        child: useContainerWrapper
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark,
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: bodyPadding ?? const EdgeInsets.all(24.0),
                  child: body,
                ),
              )
            : Padding(
                padding: bodyPadding ?? const EdgeInsets.all(24.0),
                child: body,
              ),
      ),
    );
  }
}
