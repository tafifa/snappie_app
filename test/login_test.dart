import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snappie_app/app/core/constants/app_constants.dart';
import 'package:snappie_app/app/core/helpers/api_response_helper.dart';
import 'package:snappie_app/app/core/helpers/json_mapping_helper.dart';
import 'package:snappie_app/app/core/network/dio_client.dart';

Future<bool> login(String email) async {
  try {
    // final dio = Dio();
    final DioClient dioClient = DioClient();

    // Debug: Print request details
    final requestUrl =
        '${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/login';
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
      options: Options(headers: requestHeaders),
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
      // _userEmail = email;
      // print('Email to save: $email');
      // _token = token;
      // print('Token to save: $token');

      final userJson = flattenAdditionalInfoForUser(data, removeContainer: false);
      // _userData = UserModel.fromJson(userJson);
      print('User Data to save: $userJson');

      // Save to SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString(_tokenKey, token);
      // await prefs.setString(_userEmailKey, email);
      // await prefs.setString(_userDataKey, jsonEncode(userData));

      print('💾 AUTH DATA SAVED SUCCESSFULLY');
      print('📱 AUTH STATUS AFTER SAVE: true');

      // Update observable
      // _isLoggedIn.value = true;

      return true;
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

void main() {
  test('Login Test', () async {
    final email = 'aninr@gmail.com';
    final result = await login(email);
    expect(result, isTrue);
  });
}