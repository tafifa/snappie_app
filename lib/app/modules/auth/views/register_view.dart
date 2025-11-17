import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/constants/app_colors.dart';
import 'package:snappie_app/app/modules/shared/layout/views/detail_layout.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailLayout(
      isCard: true,
      title: 'Snappie',
      onBackPressed: () {
        if (controller.selectedPageIndex > 0) {
          controller.previousPage();
        } else {
          controller.cancelRegistration();
        }
      },
      body: Column(
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Gabung dengan Kami',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Eksplorasi tempat kuliner hidden gems, nikmati pengalaman kuliner yang tak terlupakan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Progress Indicator
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  height: 8,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: index <= controller.selectedPageIndex
                                        ? AppColors.accent
                                        : AppColors.accent.withAlpha(75),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Page Content
                    Obx(() {
                      switch (controller.selectedPageIndex) {
                        case 0:
                          return _buildInputDataUser();
                        case 1:
                          return _buildInputFoodType();
                        case 2:
                          return _buildInputPlaceValue();
                        default:
                          return _buildInputDataUser();
                      }
                    }),

                    const SizedBox(height: 24),

                    // Navigation Buttons
                    Obx(() => Row(
                          children: [
                            if (controller.selectedPageIndex > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: controller.previousPage,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    side: BorderSide(color: AppColors.primary),
                                  ),
                                  child: Text(
                                    'Kembali',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            if (controller.selectedPageIndex > 0)
                              const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (controller.selectedPageIndex < 2) {
                                    controller.nextPage();
                                  } else {
                                    controller.register();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  disabledBackgroundColor: Colors.grey.shade300,
                                ),
                                child: Text(
                                  controller.selectedPageIndex < 2
                                      ? 'Lanjut'
                                      : 'Daftar',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputDataUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Form Section Title
        const Text(
          'Lengkapi profil kamu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),

        // Email field (read-only, from Google)
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.registerEmailController,
          enabled: false,
          decoration: InputDecoration(
            hintText: 'Email dari akun Google',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),

        // First Name and Last Name Row
        const Text(
          'Nama Depan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  hintText: 'Nama Depan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Nama Belakang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Gender Selection
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => RadioGroup<Gender>(
            groupValue: controller.selectedGenderEnum,
            onChanged: (Gender? value) {
              if (value != null) controller.setGender(value);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => controller.setGender(Gender.male),
                  child: Row(
                    children: [
                      Radio<Gender>(
                        value: Gender.male,
                      ),
                      const Text('Laki-laki'),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () => controller.setGender(Gender.female),
                  child: Row(
                    children: [
                      Radio<Gender>(
                        value: Gender.female,
                      ),
                      const Text('Perempuan'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Show avatar picker button if gender is selected
        Obx(
          () => controller.selectedGender.value != 'others'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar grid (show/hide based on toggle)
                    Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: controller.selectedGender.value.isNotEmpty
                            ? null
                            : 0,
                        child: controller.selectedGender.value.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pilih Avatar',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: controller
                                        .getAvatarOptions(
                                            controller.selectedGender.value)
                                        .length,
                                    itemBuilder: (context, index) {
                                      final avatar =
                                          controller.getAvatarOptions(controller
                                              .selectedGender.value)[index];
                                      return GestureDetector(
                                        onTap: () {
                                          controller.setAvatar(avatar['path']);
                                        },
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  avatar['color'].withAlpha(75),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: controller.selectedAvatar
                                                            .value ==
                                                        avatar['path']
                                                    ? AppColors.primary
                                                    : Colors.transparent,
                                                width: controller.selectedAvatar
                                                            .value ==
                                                        avatar['path']
                                                    ? 3
                                                    : 0,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: ClipRRect(
                                              child: Image.network(
                                                avatar['path'],
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                              loadingProgress.expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  // Fallback to local asset if network fails
                                                  return Image.asset(
                                                    avatar['localPath'],
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return const Icon(Icons.person, size: 40);
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),

        // Username field
        const Text(
          'Nama Pengguna',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Minimal 8 kata dan mengandung karakter atau angka',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.usernameController,
          decoration: InputDecoration(
            hintText: 'Contoh: marissa.ana_',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildInputFoodType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Pilih 3 atau lebih tipe kuliner yang kamu sukai',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),

          // Food type selection grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: controller.foodTypes.length,
            itemBuilder: (context, index) {
              final foodType = controller.foodTypes[index];
              
              // Map food types to icons
              final Map<String, String> foodIcons = {
                'Nusantara': '🍜',
                'Internasional': '🌍',
                'Seafood': '🦞',
                'Kafein': '☕',
                'Non-Kafein': '🧃',
                'Vegetarian': '🥗',
                'Dessert': '🍰',
                'Makanan Ringan': '🍿',
                'Pastry': '🥐',
              };
              
              return Obx(
                () {
                  final isSelected =
                      controller.selectedFoodTypes.contains(foodType);
                  
                  return GestureDetector(
                    onTap: () {
                      controller.toggleFoodTypeSelection(foodType);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withAlpha(100)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            foodIcons[foodType] ?? '🍴',
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            foodType,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? AppColors.primary : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          
          const SizedBox(height: 16),
        ],
    );
  }

  Widget _buildInputPlaceValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Pilih 3 atau lebih nilai tempat yang kamu cari',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
          
          // Place value selection grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: controller.placeValues.length,
            itemBuilder: (context, index) {
              final placeValue = controller.placeValues[index];
              
              return Obx(
                () {
                  final isSelected =
                      controller.selectedPlaceValues.contains(placeValue);
                  
                  return GestureDetector(
                    onTap: () {
                      controller.togglePlaceValueSelection(placeValue);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withAlpha(100)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text(
                        placeValue,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppColors.primary : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          
          const SizedBox(height: 16),
        ],
    );
  }
}
