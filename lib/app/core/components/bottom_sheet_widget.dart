import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BottomSheetWidget extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool showHandle;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<Widget>? actions;

  const BottomSheetWidget({
    super.key,
    this.title,
    required this.child,
    this.padding,
    this.height,
    this.showHandle = true,
    this.isScrollControlled = true,
    this.backgroundColor,
    this.borderRadius,
    this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? height,
    bool showHandle = true,
    bool isScrollControlled = true,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    List<Widget>? actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetWidget(
        title: title,
        padding: padding,
        height: height,
        showHandle: showHandle,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        actions: actions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: borderRadius ?? const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            if (showHandle)
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            
            // Title
            if (title != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            
            // Content
            Flexible(
              child: Container(
                padding: padding ?? const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
