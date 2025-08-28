import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService;
  
  AuthController({required this.authService});
  
  final TextEditingController emailController = TextEditingController();
  final _isLoading = false.obs;
  final _isLoggedIn = false.obs;
  
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  
  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in
    _isLoggedIn.value = authService.isLoggedIn;
  }
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
  
  Future<void> login() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    _setLoading(true);
    
    try {
      final success = await authService.login(emailController.text.trim());
      
      if (success) {
        _isLoggedIn.value = true;
        
        // Navigate to main app
        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          'Error',
          'Login failed. Please check your email or try again.',
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
  
  void skipLogin() {
    // For development - skip authentication
    _isLoggedIn.value = true;
    Get.snackbar(
      'Development Mode',
      'Login skipped for development',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
    
    // Navigate to main app
    Get.offAllNamed('/main');
  }
  
  void logout() {
    authService.logout();
    _isLoggedIn.value = false;
    emailController.clear();
    
    Get.snackbar(
      'Logged Out',
      'You have been logged out',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    
    // Navigate back to login
    Get.offAllNamed('/login');
  }
  
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
}
