import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User profile observables
  final RxString userName = 'John Doe'.obs;
  final RxString userEmail = 'john.doe@example.com'.obs;
  final RxString userAvatar = ''.obs;
  final RxInt totalCheckins = 0.obs;
  final RxInt totalReviews = 0.obs;
  final RxInt totalPlaces = 0.obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isUpdatingProfile = false.obs;
  
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Mock data loading
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock statistics
      totalCheckins.value = 15;
      totalReviews.value = 8;
      totalPlaces.value = 12;
      
    } catch (e) {
      errorMessage.value = 'Failed to load profile';
    }
    
    isLoading.value = false;
  }
  
  // Update profile
  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    isUpdatingProfile.value = true;
    errorMessage.value = '';
    
    try {
      // Mock profile update
      await Future.delayed(const Duration(milliseconds: 1000));
      
      userName.value = name;
      userEmail.value = email;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update profile';
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    
    isUpdatingProfile.value = false;
  }
  
  // Logout
  void logout() {
    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Perform logout
              Get.offAllNamed('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
