import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/google_auth_service.dart';
import '../../../routes/app_pages.dart';

class TestingRegisterController extends GetxController {
  final AuthService authService;
  final GoogleAuthService googleAuthService;
  
  TestingRegisterController({required this.authService, required this.googleAuthService});
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  final _isLoading = false.obs;
  final _googleUserName = ''.obs;
  final _googleUserEmail = ''.obs;
  
  bool get isLoading => _isLoading.value;
  String get googleUserName => _googleUserName.value;
  String get googleUserEmail => _googleUserEmail.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadGoogleUserData();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.onClose();
  }
  
  void _loadGoogleUserData() {
    // Get user data from Google Auth Service
    final user = googleAuthService.currentUser;
    if (user != null) {
      _googleUserName.value = user.displayName ?? '';
      _googleUserEmail.value = user.email ?? '';
      
      // Pre-fill form fields
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
      
      // Generate suggested username from email
      if (user.email != null) {
        final emailParts = user.email!.split('@');
        if (emailParts.isNotEmpty) {
          usernameController.text = emailParts[0];
        }
      }
    }
  }
  
  Future<void> register() async {
    if (!_validateForm()) {
      return;
    }
    
    _setLoading(true);
    
    try {
      final success = await authService.registerUser(
        name: nameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        gender: 'female',
        imageUrl: 'https://static.wikia.nocookie.net/akb48/images/9/94/Anindya_Ramadhani_JKT48_12th_Anniversary.jpg/revision/latest/scale-to-width-down/1000?cb=20250605013934',
        foodTypes: ['Nusantara', 'Internasional'],
        placeValues: ['Harga Terjangkau', 'Buka 24 Jam'],
      );
      
      if (success) {
        Get.snackbar(
          'Success',
          'Registration completed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to main app
        Get.offAllNamed(AppPages.MAIN);
      } else {
        Get.snackbar(
          'Error',
          'Registration failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: Please check your connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    
    _setLoading(false);
  }
  
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (usernameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a username',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    // Basic username validation
    final username = usernameController.text.trim();
    if (username.length < 3) {
      Get.snackbar(
        'Error',
        'Username must be at least 3 characters long',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    // Check for valid username characters
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      Get.snackbar(
        'Error',
        'Username can only contain letters, numbers, and underscores',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }
  
  void cancelRegistration() {
    // Sign out from Google and return to login
    googleAuthService.signOut();
    Get.offAllNamed(AppPages.LOGIN_TEST);
    
    Get.snackbar(
      'Cancelled',
      'Registration cancelled',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
  
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
}
