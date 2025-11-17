import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/network/dio_client.dart';
import 'package:snappie_app/app/core/services/auth_service.dart';

void main() {
  group('DioClient Tests', () {
    const String baseUrl = 'http://192.168.18.135:3000';
    const String apiVersion = '/api/v1';
    const String testEmail = 'aninr@gmail.com';

    late DioClient dioClient;

    setUp(() {
      // Setup GetX dependencies
      Get.put<AuthService>(AuthService(), permanent: true);
      dioClient = DioClient();
    });

    tearDown(() {
      Get.reset();
    });

    test('Test DioClient Connection to Server', () async {
      print('\n========================================');
      print('🌐 Testing DioClient Server Connection');
      print('========================================');
      print('Server URL: \$baseUrl');
      print('Testing if server is reachable with DioClient...\n');

      try {
        final response = await dioClient.dio.get(
          '\$baseUrl',
          options: Options(
            validateStatus: (status) => status != null && status < 500,
          ),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception('⏱️ Server timeout - tidak merespons dalam 15 detik');
          },
        );

        print('✅ DioClient Server is reachable!');
        print('Status: \${response.statusCode}');
        print('Headers: \${response.headers}');
        
        expect(response.statusCode, lessThan(500));
      } catch (e) {
        print('❌ DioClient Server check failed: \$e');
        if (e is DioException) {
          print('Error Type: \${e.type}');
          print('Error Message: \${e.message}');
          print('Error Details: \${e.error}');
        }
        fail('DioClient cannot connect to server: \$e');
      }
    });

    test('Test DioClient Login API Endpoint', () async {
      print('\n========================================');
      print('🔐 Testing DioClient Login API Endpoint');
      print('========================================');
      print('URL: \$baseUrl\$apiVersion/auth/login');
      print('Email: \$testEmail\n');

      final requestUrl = '\$baseUrl\$apiVersion/auth/login';
      final requestData = {'email': testEmail};

      try {
        print('📤 Sending login request with DioClient...');
        final startTime = DateTime.now();

        final response = await dioClient.dio.post(
          requestUrl,
          data: requestData,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) => status != null && status < 500,
          ),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception('⏱️ Request timeout - server tidak merespons dalam 15 detik');
          },
        );

        final elapsed = DateTime.now().difference(startTime).inMilliseconds;
        print('✅ Response received in \${elapsed}ms');
        print('Status Code: \${response.statusCode}');
        print('Response Data: \${response.data}');

        // Assertions
        expect(response.statusCode, isNotNull);
        
        // Check if successful login or user not found
        if (response.statusCode == 200) {
          print('✅ Login successful!');
          expect(response.data, isNotNull);
          expect(response.data['success'], isTrue);
          expect(response.data['data'], isNotNull);
          expect(response.data['data']['token'], isNotNull);
          expect(response.data['data']['user'], isNotNull);
        } else if (response.statusCode == 404 || response.statusCode == 422) {
          print('🔍 User not found - needs registration');
          expect(response.statusCode, anyOf(equals(404), equals(422)));
        } else {
          print('⚠️ Unexpected status code: \${response.statusCode}');
        }

      } catch (e) {
        print('❌ DioClient Login test failed: \$e');
        
        if (e is DioException) {
          print('\n📊 Error Details:');
          print('Error Type: \${e.type}');
          print('Error Message: \${e.message}');
          
          if (e.type == DioExceptionType.connectionTimeout) {
            print('⏱️ Connection Timeout - Server tidak merespons');
          } else if (e.type == DioExceptionType.receiveTimeout) {
            print('⏱️ Receive Timeout - Server lambat merespons');
          } else if (e.type == DioExceptionType.connectionError) {
            print('🔌 Connection Error - Tidak dapat terhubung ke server');
            print('Detail: \${e.error}');
          } else if (e.type == DioExceptionType.badCertificate) {
            print('🔐 SSL Certificate Error');
          }
          
          if (e.response != null) {
            print('Response Status: \${e.response?.statusCode}');
            print('Response Data: \${e.response?.data}');
          }
        }
        
        fail('DioClient Login API test failed: \$e');
      }
    });
  });
}