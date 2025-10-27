class EnvironmentConfig {
  // Single environment configuration - always development for now
  
  // Option 1: Environment Type
  static const String environmentType = 'production';
  
  // Option 2: Host IP Address (works for real device & emulator)
  static const String hostBaseUrl = 'https://evway.my.id';
  
  // Option 3: localhost (only for web/desktop)
  static const String localBaseUrl = 'http://192.168.18.11:8000';
  // static const String localBaseUrl = 'http://172.16.5.211:8000';

  static const String apiVersion = '/api/v1';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Option 4: Select Environment Type
  static String get baseUrl {
    switch (environmentType) {
      case 'development':
        return localBaseUrl;
      case 'production':
        return hostBaseUrl;
      default:
        return localBaseUrl;
    }
  }

  static String get fullApiUrl => '$baseUrl$apiVersion';
  
  // Logging configuration
  static const bool enableLogging = true;
  static const bool enableVerboseLogging = true;
}
