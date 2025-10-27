import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/services/google_auth_service.dart';
import 'package:snappie_app/app/routes/app_pages.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/remote_assets.dart';

enum Gender { male, female, others }

class AuthController extends GetxController {
  final AuthService authService;
  final GoogleAuthService googleAuthService;
  
  AuthController({required this.authService, required this.googleAuthService});
  
  // Login form controllers
  final TextEditingController emailController = TextEditingController();
  
  // Register form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  
  final _isLoading = false.obs;
  final _selectedPageIndex = 0.obs;
  final _isLoggedIn = false.obs;
  final _googleUserName = ''.obs;
  final _googleUserEmail = ''.obs;
  final _agreedToTerms = false.obs;
  final _selectedGender = ''.obs;
  final _selectedAvatar = ''.obs;
  final _showAvatarPicker = false.obs;
  final _selectedFoodTypes = <String>[].obs;
  final _selectedPlaceValues = <String>[].obs;
  
  // Food type options
  final List<String> foodTypes = [
    'Nusantara',
    'Internasional',
    'Seafood',
    'Kafein',
    'Non-Kafein',
    'Vegetarian',
    'Dessert',
    'Makanan Ringan',
    'Pastry',
  ];
  
  // Place value options
  final List<String> placeValues = [
    'Harga Terjangkau',
    'Rasa Autentik',
    'Menu Bervariasi',
    'Buka 24 Jam',
    'Jaringan Lancar',
    'Estetika',
    'Suasana Tenang',
    'Suasana Tradisional',
    'Suasana Homey',
    'Pet Friendly',
    'Ramah Keluarga',
    'Pelayanan Ramah',
    'Cocok untuk Nongkrong',
    'Cocok untuk Work From Cafe',
    'Tempat Bersejarah',
  ];
  
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get googleUserName => _googleUserName.value;
  String get googleUserEmail => _googleUserEmail.value;
  RxBool get agreedToTerms => _agreedToTerms;
  RxString get selectedGender => _selectedGender;
  Gender get selectedGenderEnum {
    if (_selectedGender.value.toLowerCase() == 'male') {
      return Gender.male;
    } else if (_selectedGender.value.toLowerCase() == 'female') {
      return Gender.female;
    }
    return Gender.others;
  }
  RxString get selectedAvatar => _selectedAvatar;
  RxBool get showAvatarPicker => _showAvatarPicker;
  int get selectedPageIndex => _selectedPageIndex.value;
  RxList<String> get selectedFoodTypes => _selectedFoodTypes;
  RxList<String> get selectedPlaceValues => _selectedPlaceValues;
  
  // Keep controller alive during auth flow
  @override
  bool get isClosed => false;
  
  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in
    _isLoggedIn.value = authService.isLoggedIn;
    _loadGoogleUserData();
  }
  
  @override
  void onClose() {
    // Clear content but don't dispose - controller is reused in auth flow
    emailController.clear();
    nameController.clear();
    usernameController.clear();
    registerEmailController.clear();
    super.onClose();
  }
  
  void _loadGoogleUserData() {
    try {
      // Get user data from Google Auth Service
      final user = googleAuthService.currentUser;
      if (user != null) {
        print('📱 Loading Google user data:');
        print('Name: ${user.displayName}');
        print('Email: ${user.email}');

        _googleUserEmail.value = user.email ?? '';
        
        if (user.email != null && user.email!.isNotEmpty) {
          registerEmailController.text = user.email!;
        }
        
        print('✅ Google user data loaded successfully');
      } else {
        print('⚠️ No Google user found');
      }
    } catch (e) {
      print('❌ Error loading Google user data: $e');
    }
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
        Get.offAllNamed(AppPages.MAIN);
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

  Future<void> loginWithGoogle() async {
    _setLoading(true);
    
    try {
      final success = await authService.signInWithGoogle();
      
      if (success) {
        _isLoggedIn.value = true;
        
        // Navigate to main app
        Get.offAllNamed(AppPages.MAIN);
      } else {
        Get.snackbar(
          'Error',
          'Google Sign In failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Check if user not found and needs registration
      if (e == 'USER_NOT_FOUND') {
        print('🔍 User not found, navigating to registration');
        // Load Google user data before navigating
        _loadGoogleUserData();
        Get.offAllNamed('/register');
        return;
      }
      
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

  Future<void> signUpWithGoogle() async {
    _setLoading(true);
    
    try {
      final success = await authService.signInWithGoogle();
      
      if (success) {
        _loadGoogleUserData();
        // Navigate to registration page
        Get.offAllNamed('/register');
      } else {
        Get.snackbar(
          'Error',
          'Google Sign Up failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Check if user not found and needs registration
      if (e == 'USER_NOT_FOUND') {
        print('🔍 User not found, navigating to registration');
        _loadGoogleUserData();
        Get.offAllNamed('/register');
        return;
      }
      
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
  
  // ========== REGISTRATION METHODS ==========
  
  Future<void> register() async {
    if (!_validateForm()) {
      return;
    }
    
    _setLoading(true);
    
    // Show info snackbar
    Get.snackbar(
      'Processing',
      'Mendaftarkan akun Anda, mohon tunggu...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    
    try {
      final success = await authService.registerUser(
        name: nameController.text.trim(),
        username: usernameController.text.trim(),
        email: registerEmailController.text.trim(),
        gender: _selectedGender.value,
        imageUrl: _selectedAvatar.value, // Use selected avatar from remote assets
        foodTypes: _selectedFoodTypes.toList(),
        placeValues: _selectedPlaceValues.toList(),
      );
      
      print('✅ Registration attempt completed: $success');

      if (success) {
        // Set loading false before navigation
        _setLoading(false);
        
        Get.snackbar(
          'Berhasil',
          'Registrasi berhasil! Selamat datang di Snappie',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Small delay before navigation to ensure everything is ready
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Navigate to home (main app layout)
        Get.offAllNamed(AppPages.MAIN);
        print('✅ Navigation to home successful');
        
        return; // Exit early to avoid setting loading again
      } else {
        Get.snackbar(
          'Gagal',
          'Registrasi gagal. Silakan coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Registration error: $e');
      print('❌ Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Server membutuhkan waktu lama atau koneksi bermasalah. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
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
    
    if (registerEmailController.text.trim().isEmpty) {
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
    
    // Validate gender
    if (_selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select your gender',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    // Validate avatar
    if (_selectedAvatar.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an avatar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    // Validate food types (minimum 3)
    if (_selectedFoodTypes.length < 3) {
      Get.snackbar(
        'Error',
        'Please select at least 3 food types',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    // Validate place values (minimum 3)
    if (_selectedPlaceValues.length < 3) {
      Get.snackbar(
        'Error',
        'Please select at least 3 place values',
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
    Get.offAllNamed('/login');
    
    Get.snackbar(
      'Cancelled',
      'Registration cancelled',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
  
  // ========== SHARED METHODS ==========
  
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
    Get.offAllNamed(AppPages.MAIN);
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

  void setGender(Gender gender) {
    _selectedGender.value = gender.toString().split('.').last;
    print('✅ Gender selected: $gender');
  }

  void setAvatar(String avatar) {
    _selectedAvatar.value = avatar;
    print('✅ Avatar selected: $avatar');
  }

  void toggleAvatarPicker() {
    _showAvatarPicker.value = !_showAvatarPicker.value;
    print('🎨 Avatar picker toggled: ${_showAvatarPicker.value}');
  }

  void nextPage() {
    if (_selectedPageIndex.value < 2) {
      _selectedPageIndex.value++;
      print('📄 Moving to page: ${_selectedPageIndex.value}');
    }
  }

  void previousPage() {
    if (_selectedPageIndex.value > 0) {
      _selectedPageIndex.value--;
      print('📄 Moving to page: ${_selectedPageIndex.value}');
    }
  }

  void goToPage(int index) {
    if (index >= 0 && index <= 2) {
      _selectedPageIndex.value = index;
      print('📄 Going to page: ${_selectedPageIndex.value}');
    }
  }

  void toggleFoodTypeSelection(String foodType) {
    if (_selectedFoodTypes.contains(foodType)) {
      _selectedFoodTypes.remove(foodType);
      print('❌ Food type removed: $foodType');
    } else {
      _selectedFoodTypes.add(foodType);
      print('✅ Food type selected: $foodType');
    }
    print('📋 Total selected: ${_selectedFoodTypes.length} - ${_selectedFoodTypes.join(", ")}');
  }

  void togglePlaceValueSelection(String placeValue) {
    if (_selectedPlaceValues.contains(placeValue)) {
      _selectedPlaceValues.remove(placeValue);
      print('❌ Place value removed: $placeValue');
    } else {
      _selectedPlaceValues.add(placeValue);
      print('✅ Place value selected: $placeValue');
    }
    print('📍 Total selected: ${_selectedPlaceValues.length} - ${_selectedPlaceValues.join(", ")}');
  }

  List<Map<String, dynamic>> getAvatarOptions(String gender) {
    if (gender.toLowerCase() == 'male') {
      return [
        {
          'path': RemoteAssets.avatar('avatar_m1_hdpi.png'),
          'localPath': RemoteAssets.localAvatar('avatar_m1_hdpi.png'),
          'color': Colors.blue
        },
        {
          'path': RemoteAssets.avatar('avatar_m2_hdpi.png'),
          'localPath': RemoteAssets.localAvatar('avatar_m2_hdpi.png'),
          'color': Colors.green
        },
        {
          'path': RemoteAssets.avatar('avatar_m3_hdpi.png'),
          'localPath': RemoteAssets.localAvatar('avatar_m3_hdpi.png'),
          'color': Colors.orange
        },
        {
          'path': RemoteAssets.avatar('avatar_m4_hdpi.png'),
          'localPath': RemoteAssets.localAvatar('avatar_m4_hdpi.png'),
          'color': Colors.grey
        },
      ];
    }
    return [
      {
        'path': RemoteAssets.avatar('avatar_f1_hdpi.png'),
        'localPath': RemoteAssets.localAvatar('avatar_f1_hdpi.png'),
        'color': Colors.orange
      },
      {
        'path': RemoteAssets.avatar('avatar_f2_hdpi.png'),
        'localPath': RemoteAssets.localAvatar('avatar_f2_hdpi.png'),
        'color': Colors.yellow
      },
      {
        'path': RemoteAssets.avatar('avatar_f3_hdpi.png'),
        'localPath': RemoteAssets.localAvatar('avatar_f3_hdpi.png'),
        'color': Colors.green
      },
      {
        'path': RemoteAssets.avatar('avatar_f4_hdpi.png'),
        'localPath': RemoteAssets.localAvatar('avatar_f4_hdpi.png'),
        'color': Colors.pink
      },
    ];
  }
}
