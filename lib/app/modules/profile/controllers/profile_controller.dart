import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../core/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService authService;
  
  ProfileController({required this.authService});
  
  final _userProfile = <String, dynamic>{}.obs;
  final _isLoading = false.obs;

  Map<String, dynamic> get userProfile => _userProfile;
  bool get isLoading => _isLoading.value;

  UserEntity? get user => _userProfile['user'] as UserEntity?;
  Map<String, dynamic>? get stats => _userProfile['stats'] as Map<String, dynamic>?;
  List<Map<String, dynamic>>? get recentActivity => _userProfile['recentActivity'] as List<Map<String, dynamic>>?;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    
    // Listen for auth status changes
    ever(authService.isLoggedInObs, (isLoggedIn) {
      if (isLoggedIn) {
        loadUserProfile();
      }
    });
  }

  Future<void> loadUserProfile() async {
    _setLoading(true);
    
    try {
      // Load user data from AuthService
      if (authService.isLoggedIn) {
        final userData = authService.userData;
        if (userData != null) {
          _userProfile.value = {
            'user': UserEntity(
              id: userData['id'] ?? '',
              email: userData['email'] ?? '',
              name: userData['name'] ?? '',
              avatar: userData['avatar'],
              createdAt: DateTime.now(), // TODO: Parse from API
              updatedAt: DateTime.now(), // TODO: Parse from API
              isActive: userData['is_active'] ?? true,
            ),
            'stats': {
              'total_checkins': userData['total_checkins'] ?? 0,
              'total_reviews': userData['total_reviews'] ?? 0,
              'total_points': userData['total_points'] ?? 0,
              'level': userData['level'] ?? 1,
            },
            'recentActivity': [], // TODO: Load from API
          };
          
          print('👤 User profile loaded: ${userData['name']}');
        } else {
          print('❌ No user data available');
        }
      } else {
        print('❌ User not logged in');
      }
    } catch (e) {
      print('❌ Error loading user profile: $e');
    }
    
    _setLoading(false);
  }

  Future<void> refreshProfile() async {
    await loadUserProfile();
  }

  void editProfile() {
    // TODO: Implement edit profile functionality
    Get.snackbar(
      'Edit Profile',
      'Edit profile feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void changePassword() {
    // TODO: Implement change password functionality
    Get.snackbar(
      'Change Password',
      'Change password feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> logout() async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        // Show loading
        Get.dialog(
          Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );
        
        // Call logout API
        await authService.logout();
        
        // Close loading dialog
        Get.back();
        
        // Show success message
        Get.snackbar(
          'Logout Berhasil',
          'Anda telah keluar dari aplikasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate back to login screen
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void viewAchievements() {
    // TODO: Implement view achievements functionality
    Get.snackbar(
      'Achievements',
      'View achievements feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewHistory() {
    // TODO: Implement view history functionality
    Get.snackbar(
      'History',
      'View history feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
}
