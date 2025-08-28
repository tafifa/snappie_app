import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LoadingStateWidget extends StatelessWidget {
  final String? message;
  final bool isSliver;
  final double? size;

  const LoadingStateWidget({
    super.key,
    this.message,
    this.isSliver = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (isSliver) {
      return SliverFillRemaining(
        child: loadingWidget,
      );
    }

    return loadingWidget;
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const LoadingIndicatorWidget({
    super.key,
    this.size,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: CircularProgressIndicator(
            color: color ?? AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
