import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio_lib;
import 'package:snappie_app/app/core/helpers/api_response_helper.dart';
import 'package:snappie_app/app/core/network/dio_client.dart';
import 'package:snappie_app/app/data/models/user_model.dart';
import 'package:snappie_app/app/data/datasources/local/user_local_datasource.dart';
import '../constants/app_constants.dart';
import '../constants/environment_config.dart';
import '../../routes/api_endpoints.dart';
import '../helpers/json_mapping_helper.dart';
import 'google_auth_service.dart';

class AuthService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userDataKey = 'user_data';

  String? _token;
  String? _userEmail;
  UserModel? _userData;

  // Observable for login status
  final _isLoggedIn = false.obs;
  RxBool get isLoggedInObs => _isLoggedIn;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadAuthData();
  }

  bool get isLoggedIn {
    final loggedIn = _token != null && _token!.isNotEmpty;
    _isLoggedIn.value = loggedIn;
    return loggedIn;
  }

  String? get token => _token;
  String? get userEmail => _userEmail;
  UserModel? get userData => _userData;

  Future<void> _loadAuthData() async {
    try {
      print('📱 LOADING AUTH DATA FROM STORAGE...');
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
      _userEmail = prefs.getString(_userEmailKey);
      final userDataString = prefs.getString(_userDataKey);

      print('📱 LOADED AUTH DATA:');
      print('Token: $_token');
      print('Email: $_userEmail');
      print('User Data String: $userDataString');

      if (userDataString != null && userDataString.isNotEmpty) {
        // Parse user data from JSON string
        _userData = UserModel.fromJson(
            Map<String, dynamic>.from(jsonDecode(userDataString)));
        print('User Data Parsed: ${_userData?.name}');
      }

      print('📱 AUTH STATUS AFTER LOAD: ${isLoggedIn}');

      // Update observable
      _isLoggedIn.value = _token != null && _token!.isNotEmpty;
    } catch (e) {
      print('❌ Error loading auth data: $e');
    }
  }

  Future<bool> login(String email) async {
    try {
      final DioClient dioClient = DioClient();

      // Debug: Print request details
      final requestUrl = '${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/login';
      final requestData = {'email': email};
      final requestHeaders = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      print('🔐 LOGIN REQUEST:');
      print('URL: $requestUrl');
      print('Data: $requestData');
      print('Headers: $requestHeaders');

      final response = await dioClient.dio.post(
        requestUrl,
        data: requestData,
      );

      // Debug: Print response details
      print('🔐 LOGIN RESPONSE:');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final data = extractApiResponseData(response,
            (json) => Map<String, dynamic>.from(json as Map<String, dynamic>));

        final userData = data['user'];
        final token = data['token'];

        print('✅ LOGIN SUCCESS:');
        print('User: $userData');
        print('Token: $token');

        // Save auth data
        print('💾 SAVING AUTH DATA TO STORAGE...');
        _userEmail = email;
        print('Email to save: $email');
        _token = token;
        print('Token to save: $token');

        final userJson = flattenAdditionalInfoForUser(userData, removeContainer: false);
        print('User Data to save: $userJson');
        _userData = UserModel.fromJson(userJson);
        print('User Data to save: $userData');

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userEmailKey, email);
        await prefs.setString(_userDataKey, jsonEncode(userData));

        print('💾 AUTH DATA SAVED SUCCESSFULLY');
        print('📱 AUTH STATUS AFTER SAVE: ${isLoggedIn}');

        // Update observable
        _isLoggedIn.value = true;

        return true;
      } else {
        print('❌ LOGIN FAILED with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ LOGIN ERROR: $e');
      if (e is dio_lib.DioException) {
        print('DioError Type: ${e.type}');
        print('DioError Message: ${e.message}');
        print('DioError Response: ${e.response?.data}');
        print('DioError Status: ${e.response?.statusCode}');
      }
      return false;
    }
  }

  /// Sign in with Google and authenticate with backend API
  /// Returns: true if login successful, false if cancelled/error, throws 'USER_NOT_FOUND' if user needs registration
  Future<bool> signInWithGoogle() async {
    try {
      print('🔐 Starting Google Sign In with backend integration...');

      // Get GoogleAuthService instance
      final googleAuthService = Get.find<GoogleAuthService>();

      // Sign in with Google
      final userCredential = await googleAuthService.signInWithGoogle();

      if (userCredential == null) {
        print('🔐 Google Sign In was cancelled');
        return false;
      }

      final user = userCredential.user;
      if (user == null) {
        print('❌ No user data from Google Sign In');
        return false;
      }

      print('🔐 Google Sign In successful, now authenticating with backend...');
      print('User Email: ${user.email}');
      print('User Name: ${user.displayName}');
      print('User Photo: ${user.photoURL}');

      // Send Google user data to backend API
      final dio = dio_lib.Dio(
        dio_lib.BaseOptions(
          connectTimeout: const Duration(seconds: 60), // 60 seconds connection timeout
          receiveTimeout: const Duration(seconds: 60), // 60 seconds receive timeout
          sendTimeout: const Duration(seconds: 60), // 60 seconds send timeout
          followRedirects: true,
          maxRedirects: 5,
        ),
      );

      // Add logging interceptor
      dio.interceptors.add(dio_lib.LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('🌐 DIO: $obj'),
      ));

      print('🔍 Testing connection to server...');
      print('🔍 Server: ${AppConstants.baseUrl}');

      final requestUrl =
          '${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/login';
      final requestData = {
        'email': user.email,
      };

      print('🔐 GOOGLE LOGIN API REQUEST:');
      print('URL: $requestUrl');
      print('Data: $requestData');
      print('⏰ Waiting for response (timeout: 30s)...');

      final startTime = DateTime.now();
      
      dio_lib.Response? response;
      
      try {
        response = await dio.post(
          requestUrl,
          data: requestData,
          options: dio_lib.Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              // Accept all status codes to handle them manually
              return status != null && status < 500;
            },
          ),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            final elapsed = DateTime.now().difference(startTime).inSeconds;
            print('⏱️ REQUEST TIMEOUT after $elapsed seconds');
            print('❌ Login endpoint tidak merespons');
            print('💡 WORKAROUND: Asumsikan user belum terdaftar, redirect ke registrasi');
            
            throw dio_lib.DioException(
              requestOptions: dio_lib.RequestOptions(path: requestUrl),
              type: dio_lib.DioExceptionType.connectionTimeout,
              message: 'Login endpoint timeout - redirecting to register',
            );
          },
        );

        final elapsed = DateTime.now().difference(startTime).inMilliseconds;
        print('✅ Response received in ${elapsed}ms');
      } on dio_lib.DioException catch (timeoutError) {
        if (timeoutError.type == dio_lib.DioExceptionType.connectionTimeout) {
          print('🔄 Login endpoint timeout detected');
          print('🔄 Treating as USER_NOT_FOUND (workaround for slow backend)');
          
          Get.snackbar(
            'Informasi',
            'Server login lambat merespons. Silakan lengkapi data registrasi.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
          
          // Don't sign out from Google - user data needed for registration
          throw 'USER_NOT_FOUND';
        }
        rethrow;
      }

      print('🔐 GOOGLE LOGIN API RESPONSE:');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final userData = data['data']['user'];
          final token = data['data']['token'];

          print('✅ GOOGLE LOGIN SUCCESS:');
          print('User: $userData');
          print('Token: $token');

          // Save auth data
          _userEmail = user.email;
          _token = token;

          // Flatten additional_info before parsing to UserModel
          final flattenedUserData = flattenAdditionalInfoForUser(
            Map<String, dynamic>.from(userData),
            removeContainer: false,
          );
          _userData = UserModel.fromJson(flattenedUserData);

          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_userEmailKey, user.email ?? '');
          await prefs.setString(_userDataKey, jsonEncode(userData));

          print('💾 GOOGLE AUTH DATA SAVED SUCCESSFULLY');

          // Update observable
          _isLoggedIn.value = true;

          return true;
        } else {
          print('❌ GOOGLE LOGIN FAILED: ${data['message']}');

          // Sign out from Google if backend authentication failed
          await googleAuthService.signOut();
          return false;
        }
      } else {
        print('❌ GOOGLE LOGIN FAILED with status: ${response.statusCode}');

        // Check if user not found (404 or 422 - invalid email means user doesn't exist)
        if (response.statusCode == 404 || response.statusCode == 422) {
          print('🔍 User not found in database, needs registration');
          // Don't sign out from Google, user data needed for registration
          throw 'USER_NOT_FOUND';
        }

        // Sign out from Google if backend authentication failed
        await googleAuthService.signOut();
        return false;
      }
    } catch (e) {
      print('❌ GOOGLE LOGIN ERROR: $e');

      if (e is dio_lib.DioException) {
        print('DioError Type: ${e.type}');
        print('DioError Message: ${e.message}');
        print('DioError Response: ${e.response?.data}');
        print('DioError Status: ${e.response?.statusCode}');

        // Check for timeout errors
        if (e.type == dio_lib.DioExceptionType.connectionTimeout ||
            e.type == dio_lib.DioExceptionType.receiveTimeout ||
            e.type == dio_lib.DioExceptionType.sendTimeout) {
          print('⏱️ Connection timeout - Server tidak merespons');
          Get.snackbar(
            'Timeout',
            'Server tidak merespons. Silakan coba lagi.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
          
          // Sign out from Google on timeout
          try {
            final googleAuthService = Get.find<GoogleAuthService>();
            await googleAuthService.signOut();
          } catch (signOutError) {
            print('❌ Error signing out from Google: $signOutError');
          }
          
          return false;
        }

        // Check for connection errors
        if (e.type == dio_lib.DioExceptionType.connectionError) {
          print('🔌 Connection error - Tidak dapat terhubung ke server');
          print('🔍 Error details: ${e.error}');
          Get.snackbar(
            'Connection Error',
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
          
          // Sign out from Google on connection error
          try {
            final googleAuthService = Get.find<GoogleAuthService>();
            await googleAuthService.signOut();
          } catch (signOutError) {
            print('❌ Error signing out from Google: $signOutError');
          }
          
          return false;
        }

        // Check for bad certificate (SSL issues)
        if (e.type == dio_lib.DioExceptionType.badCertificate) {
          print('🔐 SSL Certificate error');
          Get.snackbar(
            'SSL Error',
            'Ada masalah dengan sertifikat keamanan server.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
          
          // Sign out from Google
          try {
            final googleAuthService = Get.find<GoogleAuthService>();
            await googleAuthService.signOut();
          } catch (signOutError) {
            print('❌ Error signing out from Google: $signOutError');
          }
          
          return false;
        }

        // Check if user not found (404 or 422)
        if (e.response?.statusCode == 404 || e.response?.statusCode == 422) {
          print('🔍 User not found in database, needs registration');
          // Don't sign out from Google, user data needed for registration
          throw 'USER_NOT_FOUND';
        }
      }

      // Re-throw if it's USER_NOT_FOUND
      if (e == 'USER_NOT_FOUND') {
        rethrow;
      }

      // Sign out from Google if there's an error
      try {
        final googleAuthService = Get.find<GoogleAuthService>();
        await googleAuthService.signOut();
      } catch (signOutError) {
        print('❌ Error signing out from Google: $signOutError');
      }

      return false;
    }
  }

  /// Register new user with backend API
  Future<bool> registerUser({
    required String name,
    required String username,
    required String email,
    required String gender,
    required String imageUrl,
    required List<String> foodTypes,
    required List<String> placeValues,
  }) async {
    try {
      print('📝 Starting user registration...');

      final dio = dio_lib.Dio(
        dio_lib.BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      final requestUrl = ApiEndpoints.getFullUrl(ApiEndpoints.register);
      final requestData = {
        'name': name,
        'username': username,
        'email': email,
        'gender': gender,
        'image_url': imageUrl,
        'food_type': foodTypes,
        'place_value': placeValues,
      };

      print('📝 REGISTER API REQUEST:');
      print('URL: $requestUrl');
      print('Data: $requestData');

      final response = await dio.post(
        requestUrl,
        data: requestData,
        options: dio_lib.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${EnvironmentConfig.registrationApiKey}',
          },
        ),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          print('⏱️ REGISTER REQUEST TIMEOUT after 60 seconds');
          throw dio_lib.DioException(
            requestOptions: dio_lib.RequestOptions(path: requestUrl),
            type: dio_lib.DioExceptionType.connectionTimeout,
            message: 'Connection timeout - Server membutuhkan waktu terlalu lama',
          );
        },
      );

      print('📝 REGISTER API RESPONSE:');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final userData = data['data']['user'];

          print('✅ REGISTRATION SUCCESS:');
          print('User: $userData');

          // Save user email for auto-login
          final userEmail = userData['email'] as String;
          
          print('🔄 Performing auto-login with email: $userEmail');
          
          // Auto-login with the registered email
          final loginSuccess = await login(userEmail);
          
          if (!loginSuccess) {
            print('❌ AUTO-LOGIN FAILED after registration');
            return false;
          }

          print('✅ AUTO-LOGIN SUCCESS after registration');
          print('💾 User is now logged in and ready to use the app');

          return true;
        } else {
          print('❌ REGISTRATION FAILED: ${data['message']}');
          return false;
        }
      } else {
        print('❌ REGISTRATION FAILED with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ REGISTRATION ERROR: $e');

      if (e is dio_lib.DioException) {
        print('DioError Type: ${e.type}');
        print('DioError Message: ${e.message}');
        print('DioError Response: ${e.response?.data}');
        print('DioError Status: ${e.response?.statusCode}');
      }

      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Call logout API if we have a token
      if (_token != null) {
        final dio = dio_lib.Dio();
        await dio.post(
          '${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/logout',
          options: dio_lib.Options(
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );
      }

      // Sign out from Google if user is signed in with Google
      try {
        final googleAuthService = Get.find<GoogleAuthService>();
        if (googleAuthService.isLoggedIn) {
          await googleAuthService.signOut();
          print('🔐 Signed out from Google');
        }
      } catch (e) {
        print('❌ Error signing out from Google: $e');
      }
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      // Clear local data regardless of API call success
      _token = null;
      _userEmail = null;
      _userData = null;

      // Update observable
      _isLoggedIn.value = false;

      // Clear from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userDataKey);
      
      // Clear cached user data from local database
      try {
        final userLocalDataSource = Get.find<UserLocalDataSource>();
        await userLocalDataSource.clearCachedUser();
        await userLocalDataSource.clearAuthToken();
        print('🗑️ Cleared local user cache');
      } catch (e) {
        print('❌ Error clearing local cache: $e');
      }
    }
  }

  // Get auth headers for API calls
  Map<String, String> getAuthHeaders() {
    if (_token != null) {
      return {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
    }
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}
