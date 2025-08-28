import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool isSliver;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.buttonText,
    this.onRetry,
    this.icon,
    this.isSliver = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget errorWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );

    if (isSliver) {
      return SliverFillRemaining(
        child: errorWidget,
      );
    }

    return errorWidget;
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;
  final IconData? icon;
  final bool isSliver;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.buttonText,
    this.onAction,
    this.icon,
    this.isSliver = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget emptyWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.article_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );

    if (isSliver) {
      return SliverFillRemaining(
        child: emptyWidget,
      );
    }

    return emptyWidget;
  }
}
