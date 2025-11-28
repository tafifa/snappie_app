import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';

/// Tipe kegagalan misi
enum MissionFailureType {
  /// Misi gagal (general)
  failed,

  /// Jaringan terputus
  networkError,
}

/// Modal gagal untuk misi
class MissionFailedModal extends StatelessWidget {
  final MissionFailureType failureType;
  final VoidCallback onRetry;

  const MissionFailedModal({
    super.key,
    required this.failureType,
    required this.onRetry,
  });

  static Future<bool?> show({
    MissionFailureType failureType = MissionFailureType.failed,
  }) {
    return Get.dialog<bool>(
      MissionFailedModal(
        failureType: failureType,
        onRetry: () => Get.back(result: true),
      ),
      barrierDismissible: false,
    );
  }

  String get _title {
    switch (failureType) {
      case MissionFailureType.failed:
        return 'Ups, Misi Gagal!';
      case MissionFailureType.networkError:
        return 'Ups, Jaringan Terputus!';
    }
  }

  String get _description {
    switch (failureType) {
      case MissionFailureType.failed:
        return 'Jangan khawatir, kamu bisa coba lagi.\nSemangat!';
      case MissionFailureType.networkError:
        return 'Jangan khawatir, kamu bisa coba lagi.\nSemangat!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mascot image with sad expression
            Image.asset(
              'assets/images/Rectangle 67.png',
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              _title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              _description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Retry button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
