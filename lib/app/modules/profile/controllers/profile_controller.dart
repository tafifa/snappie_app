import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/data/repositories/user_repository_impl.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  final AuthService authService;
  final UserRepository userRepository;

  ProfileController({
    required this.authService,
    required this.userRepository
  });

  final Rx<UserModel?> _userData = Rx<UserModel?>(null);
  final _isLoading = false.obs;
  final _isInitialized = false.obs;
  final _selectedTabIndex = 0.obs;

  UserModel? get userData => _userData.value;
  bool get isLoading => _isLoading.value;
  int get selectedTabIndex => _selectedTabIndex.value;

  // Access user data directly from UserModel
  String get userName => _userData.value?.name ?? 'User';
  String get userNickname => _userData.value?.username ?? '';
  String get userAvatar => _userData.value?.imageUrl ?? '';
  String get userEmail => _userData.value?.email ?? '';
  String get userImageUrl => _userData.value?.imageUrl ?? '';
  int get totalCheckins => _userData.value?.totalCheckin ?? 0;
  int get totalReviews => _userData.value?.totalReview ?? 0;
  int get totalPosts => _userData.value?.totalPost ?? 0;
  int get totalCoins => _userData.value?.totalCoin ?? 0;
  int get totalExp => _userData.value?.totalExp ?? 0;
  
  // Add stats getter for compatibility with profile_view
  Map<String, dynamic> get stats => {
    'total_checkins': totalCheckins,
    'total_reviews': totalReviews,
    'total_posts': totalPosts,
  };

  @override
  void onInit() {
    super.onInit();
    print('👤 ProfileController created (not initialized yet)');
    
    // Listen for auth status changes
    ever(authService.isLoggedInObs, (isLoggedIn) {
      if (isLoggedIn && _isInitialized.value) {
        loadUserProfile();
      }
    });
  }
  
  /// Initialize data hanya saat tab pertama kali dibuka
  void initializeIfNeeded() {
    if (!_isInitialized.value) {
      _isInitialized.value = true;
      print('👤 ProfileController initializing...');
      loadUserProfile();
    }
  }

  Future<void> loadUserProfile() async {
    _setLoading(true);
    
    try {
      // Load user data from AuthService
      if (authService.isLoggedIn) {
        final userData = authService.userData;
        if (userData != null) {
          _userData.value = userData;
          print('👤 User profile loaded: ${userData.name}');
          print('   - Email: ${userData.email}');
          print('   - Checkins: ${userData.totalCheckin}');
          print('   - Reviews: ${userData.totalReview}');
          print('   - Posts: ${userData.totalPost}');
        } else {
          print('❌ No user data available');
        }
      } else {
        print('❌ User not logged in');
        _userData.value = null;
      }
    } catch (e) {
      print('❌ Error loading user profile: $e');
      _userData.value = null;
    }
    
    _setLoading(false);
  }

  Future<void> refreshProfile() async {
    await loadUserProfile();
  }

  Future<void> refreshData() async {
    await refreshProfile();
  }

  void setSelectedTabIndex(int index) {
    _selectedTabIndex.value = index;
  }

  void editProfile() {
    // TODO: Implement edit profile functionality
    Get.snackbar(
      'Edit Profile',
      'Edit profile feature coming soon!',
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
