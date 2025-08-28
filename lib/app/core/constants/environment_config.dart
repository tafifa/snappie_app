class EnvironmentConfig {
  // Single environment configuration - always development for now
  
  // Option 1: Android Emulator (10.0.2.2)
  // static const String baseUrl = 'http://10.0.2.2:8000';
  
  // Option 2: Host IP Address (works for real device & emulator)
  static const String baseUrl = 'http://192.168.1.51:8000';
  
  // Option 3: localhost (only for web/desktop)
  // static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiVersion = '/api/v1';
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  
  // Computed properties
  static String get fullApiUrl => '$baseUrl$apiVersion';
  
  // Logging configuration
  static const bool enableLogging = true;
  static const bool enableVerboseLogging = true;
}
