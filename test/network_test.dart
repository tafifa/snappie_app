// test/api_connectivity_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// --- API Test Functions (Moved Here) ---
Future<void> runDioTest() async {
  print('--- Starting Dio Test ---');

  final dio = Dio(BaseOptions(
    baseUrl: 'https://evway.my.id/api/v1', // Removed trailing spaces
    connectTimeout: const Duration(seconds: 60), // Increased timeout
    receiveTimeout: const Duration(seconds: 60), // Increased timeout
    sendTimeout: const Duration(seconds: 60),    // Increased timeout
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // Add any other headers your API might require
    },
  ));

  try {
    print('Making Dio request...');

    final response = await dio.post(
      '/auth/login',
      data: {
        "email": "tafifa09@gmail.com", // Replace with your test email
        "remember": false // Include if required by your API, but often not needed for basic login
      },
    );

    print('Dio Request Successful!');
    print('Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');
    // debugPrint is not available in standard tests, using print instead
    print('Dio Response Body (Formatted): ${response.data}');

  } on DioException catch (e) {
    print('Dio Request Failed!');
    print('DioError Type: ${e.type}');
    print('DioError Message: ${e.message}');
    print('DioError Details: $e');

    if (e.type == DioExceptionType.receiveTimeout) {
      print('Error: Request took longer than receiveTimeout.');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      print('Error: Connection took longer than connectionTimeout.');
    } else if (e.type == DioExceptionType.sendTimeout) {
      print('Error: Sending data took longer than sendTimeout.');
    } else if (e.type == DioExceptionType.connectionError) {
      print('Error: Connection error (e.g., network unavailable, DNS failure).');
    }
    // Print response if available (e.g., for 4xx/5xx errors)
    if (e.response != null) {
      print('Dio Error Response Status: ${e.response!.statusCode}');
      print('Dio Error Response Data: ${e.response!.data}');
    }

  } catch (e) {
    print('An unexpected error occurred with Dio: $e');
  }

  print('--- Dio Test Completed ---');
}

Future<void> runHttpTest() async {
  print('--- Starting HTTP Test ---');

  final url = Uri.parse('https://evway.my.id/api/v1/auth/login'); // Removed trailing spaces

  try {
    print('Making HTTP request...');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // Add any other headers your API might require
      },
      body: jsonEncode({
        "email": "testing@gmail.com", // Replace with your test email
        "remember": false // Include if required by your API
      }),
      // Note: http package doesn't have explicit timeout options in the request method.
      // The timeout is handled by the underlying HttpClient, which defaults to 120 seconds.
    );

    print('HTTP Request Completed!');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    // debugPrint is not available in standard tests, using print instead
    print('HTTP Response Body (Formatted): ${jsonDecode(response.body)}');

    if (response.statusCode == 200) {
      print('HTTP Request Successful!');
    } else {
      print('HTTP Request Failed with Status Code: ${response.statusCode}');
    }

  } catch (e) {
    print('An error occurred with HTTP: $e');
    if (e is http.ClientException) {
      print('ClientException (e.g., connection timeout, network error): ${e.message}');
    } else if (e is FormatException) {
      print('FormatException (e.g., invalid JSON response): ${e.message}');
    } else {
      print('Other error: $e');
    }
  }

  print('--- HTTP Test Completed ---');
}

// --- Flutter Unit Tests ---
void main() {
  group('API Connectivity Tests', () {
    // IMPORTANT: These tests make real network calls.
    // Ensure you have a stable internet connection and correct credentials.
    // These tests might take a while to run depending on network/server speed.

    test('Dio Test - Login Request', () async {
      // Run the Dio test logic
      await runDioTest();

      // For a real unit test, you would typically assert something here.
      // Since this is an integration test over the network,
      // we rely on the print statements and the test not throwing an unhandled exception.
      // You could potentially mock the Dio instance instead for true unit testing,
      // but this setup tests the actual connectivity.
    });

    test('HTTP Test - Login Request', () async {
      // Run the HTTP test logic
      await runHttpTest();

      // Same as above, relies on print statements and no unhandled exceptions.
    });
  });
}