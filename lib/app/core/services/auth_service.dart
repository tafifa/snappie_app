import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class AuthService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userDataKey = 'user_data';
  
  String? _token;
  String? _userEmail;
  Map<String, dynamic>? _userData;
  
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
  Map<String, dynamic>? get userData => _userData;
  
  Future<void> _loadAuthData() async {
    try {
      print('📱 LOADING AUTH DATA FROM STORAGE...');
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
      _userEmail = prefs.getString(_userEmailKey);
      
      print('📱 LOADED AUTH DATA:');
      print('Token: $_token');
      print('Email: $_userEmail');
      
      final userDataString = prefs.getString(_userDataKey);
      if (userDataString != null) {
        print('User Data String: $userDataString');
        // Parse user data from JSON string
        _userData = Map<String, dynamic>.from(
          // Simple JSON parsing for now
          userDataString.replaceAll('{', '').replaceAll('}', '')
              .split(',')
              .map((e) {
            final parts = e.split(':');
            if (parts.length == 2) {
              return MapEntry(parts[0].trim().replaceAll('"', ''), parts[1].trim().replaceAll('"', ''));
            }
            return null;
          }).where((e) => e != null).cast<MapEntry<String, String>>()
              .fold<Map<String, dynamic>>({}, (map, entry) => map..addAll({entry.key: entry.value}))
        );
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
      final dio = Dio();
      
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
      
      final response = await dio.post(
        requestUrl,
        data: requestData,
        options: Options(
          headers: requestHeaders,
        ),
      );
      
      // Debug: Print response details
      print('🔐 LOGIN RESPONSE:');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('Headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['data'] != null) {
          final userData = data['data']['user'];
          final token = data['data']['token'];
          
          print('✅ LOGIN SUCCESS:');
          print('User: $userData');
          print('Token: $token');
          
          // Save auth data
          _userEmail = email;
          _token = token;
          _userData = Map<String, dynamic>.from(userData);
          
          print('💾 SAVING AUTH DATA TO STORAGE...');
          print('Token to save: $token');
          print('Email to save: $email');
          print('User Data to save: $userData');
          
          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_userEmailKey, email);
          await prefs.setString(_userDataKey, userData.toString());
          
          print('💾 AUTH DATA SAVED SUCCESSFULLY');
          print('📱 AUTH STATUS AFTER SAVE: ${isLoggedIn}');
          
          // Update observable
          _isLoggedIn.value = true;
          
          return true;
        } else {
          print('❌ LOGIN FAILED: ${data['message']}');
          return false;
        }
      } else {
        print('❌ LOGIN FAILED with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ LOGIN ERROR: $e');
      if (e is DioException) {
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
        final dio = Dio();
        await dio.post(
          '${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );
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
