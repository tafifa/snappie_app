import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/food_type.dart';
import '../../../core/constants/place_value.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/place_model.dart';
import '../controllers/mission_controller.dart';
import '../widgets/mission_loading_modal.dart';
import '../widgets/mission_success_modal.dart';
import '../widgets/mission_failed_modal.dart';
import '../widgets/mission_next_modal.dart';
import '../widgets/mission_survey_modal.dart';

/// Halaman untuk menulis ulasan misi
class MissionReviewView extends GetView<MissionController> {
  const MissionReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => _showExitConfirmation(),
        ),
        title: Text(
          'Tulis Ulasan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Green banner with reward info
                  _buildRewardBanner(),

                  // Place info card
                  _buildPlaceInfoCard(),

                  // Rating section
                  _buildRatingSection(),

                  // Photo/Video section
                  _buildPhotoVideoSection(),

                  // Food catalog section
                  _buildFoodCatalogSection(),

                  // Place value section
                  _buildPlaceValueSection(),

                  // Review text section
                  _buildReviewTextSection(),

                  // Hide username checkbox
                  _buildHideUsernameSection(),
                ],
              ),
            ),
          ),

          // Submit button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildRewardBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.primary,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.4,
          ),
          children: [
            const TextSpan(text: 'Tuliskan ulasanmu untuk mendapatkan '),
            TextSpan(
              text: '${controller.expReward} XP',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const TextSpan(text: ' dan '),
            TextSpan(
              text: '${controller.coinReward} Koin',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const TextSpan(text: '!\nDapatkan hadiah lebih banyak dengan menambahkan foto dan video'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceInfoCard() {
    final place = controller.currentPlace;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Place image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: place?.imageUrls != null && place!.imageUrls!.isNotEmpty
                ? Image.network(
                    place!.imageUrls!.first,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
          ),
          const SizedBox(width: 12),
          // Place details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place?.name ?? 'Nama Tempat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  place?.placeDetail?.address ?? 'Alamat tempat',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 70,
      height: 70,
      color: AppColors.surfaceContainer,
      child: Icon(
        Icons.image,
        color: AppColors.textTertiary,
        size: 32,
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Penilaian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => controller.rating.value = index + 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          index < controller.rating.value
                              ? Icons.star
                              : Icons.star_border,
                          color: index < controller.rating.value
                              ? AppColors.warning
                              : AppColors.textTertiary,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoVideoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambahkan 2 foto dan video',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '+10 Koin',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Foto button
              Expanded(
                child: _buildMediaButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Foto',
                  onTap: () => _pickPhoto(),
                ),
              ),
              const SizedBox(width: 12),
              // Video button
              Expanded(
                child: _buildMediaButton(
                  icon: Icons.videocam_outlined,
                  label: 'Video',
                  onTap: () => _pickVideo(),
                ),
              ),
            ],
          ),
          // Show selected media thumbnails
          Obx(() {
            final mediaCount = controller.reviewMediaPaths.length;
            if (mediaCount == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.reviewMediaPaths.map((path) {
                  return _buildMediaThumbnail(path);
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaThumbnail(String path) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            path,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: AppColors.surfaceContainer,
              child: Icon(Icons.image, color: AppColors.textTertiary),
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => controller.removeReviewMedia(path),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCatalogSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Katalog Makanan di Tempat Ini',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FoodType.values.map((foodType) {
                  final isSelected =
                      controller.selectedFoodTypes.contains(foodType);
                  return _buildSelectableChip(
                    label: foodType.label,
                    isSelected: isSelected,
                    onTap: () => controller.toggleFoodType(foodType),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildPlaceValueSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kesesuaian Tempat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PlaceValue.values.map((placeValue) {
                  final isSelected =
                      controller.selectedPlaceValues.contains(placeValue);
                  return _buildSelectableChip(
                    label: placeValue.label,
                    isSelected: isSelected,
                    onTap: () => controller.togglePlaceValue(placeValue),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewTextSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tuliskan ulasan minimal 25 karakter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.reviewController,
            maxLines: 4,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Bagikan pengalamanmu untuk membantu pengguna lain membuat pilihan sesuai preferensi mereka',
              hintStyle: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHideUsernameSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Obx(() => InkWell(
            onTap: () => controller.hideUsername.toggle(),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: controller.hideUsername.value
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: controller.hideUsername.value
                          ? AppColors.primary
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: controller.hideUsername.value
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sembunyikan username',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Obx(() => ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => _submitReview(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Kirim Ulasan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )),
        ),
      ),
    );
  }

  void _pickPhoto() {
    // TODO: Implement photo picker
    Get.snackbar(
      'Info',
      'Fitur tambah foto akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _pickVideo() {
    // TODO: Implement video picker
    Get.snackbar(
      'Info',
      'Fitur tambah video akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _submitReview() async {
    if (controller.rating.value == 0) {
      Get.snackbar(
        'Error',
        'Silakan berikan penilaian terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning,
        colorText: AppColors.textOnPrimary,
      );
      return;
    }

    if (controller.reviewController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Silakan tulis ulasan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning,
        colorText: AppColors.textOnPrimary,
      );
      return;
    }

    // Show loading modal
    MissionLoadingModal.show(message: 'Mengirim ulasan...');

    final success = await controller.submitReview();

    print('Review submission success: $success');

    // Hide loading modal
    MissionLoadingModal.hide();

    if (success) {
      // Show success modal
      final claimResult = await MissionSuccessModal.show(
        title: 'Misi Berhasil!',
        description:
            'Selamat, Anda telah menyelesaikan misi.\nKlaim ${controller.expReward} XP dan ${controller.coinReward} Koin Kamu!',
      );

      if (claimResult == true) {
        // Show next mission modal (survey)
        final continueNext = await MissionNextModal.show(
          title: 'Misi Selanjutnya!',
          description: 'Isi kuesioner di tempat ini\ndan dapatkan hadiahnya!',
        );

        if (continueNext == true) {
          // Show survey modal directly
          final surveyResult = await MissionSurveyModal.show(
            placeName: controller.currentPlace?.name ?? 'Tempat',
            coinReward: 25,
          );

          if (surveyResult != null && surveyResult.completed) {
            // Save survey answers to controller
            controller.saveSurveyAnswers(surveyResult.answers);
            
            // Show final success
            await MissionSuccessModal.show(
              title: 'Survey Selesai!',
              description: 'Terima kasih atas partisipasimu!\nKamu mendapatkan 25 Koin!',
            );
          }

          // Return to place detail
          controller.resetMission();
          Get.until((route) => route.settings.name == AppPages.PLACE_DETAIL);
        } else {
          // Return to place detail without survey
          controller.resetMission();
          Get.until((route) => route.settings.name == AppPages.PLACE_DETAIL);
        }
      }
    } else {
      // Show failed modal
      final retry = await MissionFailedModal.show(
        failureType: MissionFailureType.failed,
      );

      if (retry == true) {
        _submitReview();
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
            child: const Text('Lanjutkan Misi'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
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
