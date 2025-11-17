import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

/// Test file untuk menguji koneksi ke backend API
/// 
/// Untuk menjalankan test ini:
/// flutter test test/auth_service_test.dart
/// 
/// Atau untuk test spesifik:
/// flutter test test/auth_service_test.dart --name "Test Login API"

void main() {
  group('Auth Service API Tests', () {
    const String baseUrl = 'http://192.168.18.141:3000';
    const String apiVersion = '/api/v1';
    const String testEmail = 'letssayimweird@gmail.com';

    late Dio dio;

    setUp(() {
      // Setup Dio client untuk setiap test
      dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
    });

    test('Test Backend Server Health Check', () async {
      print('\n========================================');
      print('🏥 Testing Backend Server Connection');
      print('========================================');
      print('Server URL: $baseUrl');
      print('Testing if server is reachable...\n');

      try {
        final response = await dio.get(
          baseUrl,
          options: Options(
            validateStatus: (status) => status != null && status < 500,
          ),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception('⏱️ Server timeout - tidak merespons dalam 15 detik');
          },
        );

        print('✅ Server is reachable!');
        print('Status: ${response.statusCode}');
        print('Headers: ${response.headers}');
        
        expect(response.statusCode, lessThan(500));
      } catch (e) {
        print('❌ Server check failed: $e');
        if (e is DioException) {
          print('Error Type: ${e.type}');
          print('Error Message: ${e.message}');
          print('Error Details: ${e.error}');
        }
        fail('Server is not reachable: $e');
      }
    });

    test('Test Login API Endpoint', () async {
      print('\n========================================');
      print('🔐 Testing Login API Endpoint');
      print('========================================');
      print('URL: $baseUrl$apiVersion/auth/login');
      print('Email: $testEmail\n');

      final requestUrl = '$baseUrl$apiVersion/auth/login';
      final requestData = {'email': testEmail};

      try {
        print('📤 Sending login request...');
        final startTime = DateTime.now();

        final response = await dio.post(
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
        print('✅ Response received in ${elapsed}ms');
        print('Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');

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
          print('⚠️ Unexpected status code: ${response.statusCode}');
        }

      } catch (e) {
        print('❌ Login test failed: $e');
        
        if (e is DioException) {
          print('\n📊 Error Details:');
          print('Error Type: ${e.type}');
          print('Error Message: ${e.message}');
          
          if (e.type == DioExceptionType.connectionTimeout) {
            print('⏱️ Connection Timeout - Server tidak merespons');
          } else if (e.type == DioExceptionType.receiveTimeout) {
            print('⏱️ Receive Timeout - Server lambat merespons');
          } else if (e.type == DioExceptionType.connectionError) {
            print('🔌 Connection Error - Tidak dapat terhubung ke server');
            print('Detail: ${e.error}');
          } else if (e.type == DioExceptionType.badCertificate) {
            print('🔐 SSL Certificate Error');
          }
          
          if (e.response != null) {
            print('Response Status: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');
          }
        }
        
        fail('Login API test failed: $e');
      }
    });
});

  group('Detailed Connection Diagnostics', () {
    test('Ping Backend Server', () async {
      print('\n========================================');
      print('🔍 Backend Server Diagnostics');
      print('========================================');

      const baseUrl = 'http://192.168.18.135:3000';
      
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      print('Attempting to connect to: $baseUrl');
      print('Timeout: 60 seconds\n');

      try {
        final startTime = DateTime.now();
        
        final response = await dio.get(baseUrl);
        
        final elapsed = DateTime.now().difference(startTime).inMilliseconds;
        
        print('✅ SUCCESS!');
        print('Response Time: ${elapsed}ms');
        print('Status Code: ${response.statusCode}');
        print('Server Header: ${response.headers['server']}');
        print('Content-Type: ${response.headers['content-type']}');
        
        expect(response.statusCode, lessThan(500));
      } catch (e) {
        print('❌ FAILED!');
        
        if (e is DioException) {
          print('\nDiagnostic Information:');
          print('═' * 40);
          
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
              print('❌ CONNECTION TIMEOUT');
              print('   Penyebab: Server tidak merespons dalam waktu yang ditentukan');
              print('   Solusi:');
              print('   1. Periksa apakah server sedang online');
              print('   2. Cek firewall/antivirus yang mungkin memblokir koneksi');
              print('   3. Coba akses URL di browser');
              break;
              
            case DioExceptionType.receiveTimeout:
              print('❌ RECEIVE TIMEOUT');
              print('   Penyebab: Server lambat mengirim data');
              break;
              
            case DioExceptionType.connectionError:
              print('❌ CONNECTION ERROR');
              print('   Penyebab: Tidak dapat membuat koneksi ke server');
              print('   Detail Error: ${e.error}');
              print('   Solusi:');
              print('   1. Periksa koneksi internet');
              print('   2. Pastikan URL benar: $baseUrl');
              print('   3. Cek apakah ada proxy/VPN yang mengganggu');
              break;
              
            case DioExceptionType.badCertificate:
              print('❌ SSL CERTIFICATE ERROR');
              print('   Penyebab: Sertifikat SSL server bermasalah');
              print('   Solusi: Hubungi administrator server');
              break;
              
            default:
              print('❌ ${e.type}');
              print('   Message: ${e.message}');
          }
          
          print('═' * 40);
        } else {
          print('Error: $e');
        }
        
        fail('Cannot connect to backend server');
      }
    });
  });
}
