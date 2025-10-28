import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// ErrorStateWidget untuk menampilkan error state dengan full customization
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
