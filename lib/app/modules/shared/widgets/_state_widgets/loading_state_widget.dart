import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// LoadingStateWidget untuk menampilkan loading state
class LoadingStateWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final bool isSliver;

  const LoadingStateWidget({
    super.key,
    this.message,
    this.size = 40.0,
    this.color,
    this.isSliver = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? AppColors.primary,
            ),
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

/// LoadingIndicatorWidget - simple loading indicator without message
class LoadingIndicatorWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicatorWidget({
    super.key,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
      ),
    );
  }
}
