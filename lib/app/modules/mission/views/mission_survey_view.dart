import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/mission_controller.dart';
import '../widgets/mission_loading_modal.dart';
import '../widgets/mission_success_modal.dart';
import '../widgets/mission_failed_modal.dart';

/// Halaman untuk mengisi kuesioner/survey misi
class MissionSurveyView extends GetView<MissionController> {
  const MissionSurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => _showExitConfirmation(),
        ),
        title: Text(
          'Misi Kuesioner',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructions
                  Text(
                    'Kuesioner',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bantu kami meningkatkan layanan dengan menjawab beberapa pertanyaan singkat',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Survey questions (simple version)
                  _buildSurveyQuestion(
                    1,
                    'Bagaimana kebersihan tempat ini?',
                    'cleanliness',
                  ),
                  const SizedBox(height: 20),
                  
                  _buildSurveyQuestion(
                    2,
                    'Bagaimana pelayanan di tempat ini?',
                    'service',
                  ),
                  const SizedBox(height: 20),
                  
                  _buildSurveyQuestion(
                    3,
                    'Apakah harga sesuai dengan kualitas?',
                    'value',
                  ),
                ],
              ),
            ),
          ),
          
          // Submit button
          Container(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => _submitSurvey(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      )
                    : const Text(
                        'Submit Kuesioner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStepDot(1, true, 'Foto', completed: true),
          _buildStepLine(true),
          _buildStepDot(2, true, 'Ulasan', completed: true),
          _buildStepLine(true),
          _buildStepDot(3, true, 'Survey'),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step, bool isActive, String label, {bool completed = false}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: completed
                  ? Icon(Icons.check, color: AppColors.textOnPrimary, size: 18)
                  : Text(
                      '$step',
                      style: TextStyle(
                        color: isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Container(
      height: 2,
      width: 40,
      color: isCompleted ? AppColors.primary : AppColors.border,
    );
  }

  Widget _buildSurveyQuestion(int number, String question, String key) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. $question',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final currentValue = controller.surveyAnswers[key] as int? ?? 0;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRatingOption(1, '😞', 'Buruk', key, currentValue),
                _buildRatingOption(2, '😐', 'Cukup', key, currentValue),
                _buildRatingOption(3, '🙂', 'Baik', key, currentValue),
                _buildRatingOption(4, '😊', 'Sangat Baik', key, currentValue),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingOption(int value, String emoji, String label, String key, int currentValue) {
    final isSelected = currentValue == value;
    return GestureDetector(
      onTap: () => controller.surveyAnswers[key] = value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitSurvey() async {
    // Check if all questions are answered
    if (controller.surveyAnswers.length < 3) {
      Get.snackbar(
        'Error',
        'Silakan jawab semua pertanyaan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning,
        colorText: AppColors.textOnPrimary,
      );
      return;
    }
    
    // Show loading modal
    MissionLoadingModal.show(message: 'Loading...');

    final success = await controller.submitSurvey();

    // Hide loading modal
    MissionLoadingModal.hide();

    if (success) {
      // Show final success modal
      final claimResult = await MissionSuccessModal.show(
        title: 'Misi Berhasil!',
        description: 'Selamat, Anda telah menyelesaikan semua misi.\nKlaim 100 XP dan 50 Koin Kamu!',
      );
      
      if (claimResult == true) {
        // Reset mission and return to place detail
        controller.resetMission();
        Get.until((route) => route.settings.name == AppPages.PLACE_DETAIL);
        
        Get.snackbar(
          'Selamat!',
          'Kamu mendapatkan total 100 XP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: AppColors.textOnPrimary,
        );
      }
    } else {
      // Show failed modal
      final retry = await MissionFailedModal.show(
        failureType: MissionFailureType.failed,
      );

      if (retry == true) {
        _submitSurvey();
      }
    }
  }

  void _showExitConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Batalkan Misi?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Progress misi akan hilang jika kamu keluar sekarang.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Lanjutkan Misi'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.resetMission();
              Get.until((route) => route.settings.name == AppPages.PLACE_DETAIL);
            },
            child: Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
