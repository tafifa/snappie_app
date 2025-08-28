class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  
  NetworkException(this.message, {this.statusCode});
  
  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;
  final int statusCode;
  
  ServerException(this.message, this.statusCode);
  
  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class CacheException implements Exception {
  final String message;
  
  CacheException(this.message);
  
  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;
  
  ValidationException(this.message, {this.errors});
  
  @override
  String toString() => 'ValidationException: $message';
}

class AuthException implements Exception {
  final String message;
  final String? code;
  
  AuthException(this.message, {this.code});
  
  @override
  String toString() => 'AuthException: $message';
}

class AuthenticationException implements Exception {
  final String message;
  final String? code;
  
  AuthenticationException(this.message, {this.code});
  
  @override
  String toString() => 'AuthenticationException: $message';
}

class AuthorizationException implements Exception {
  final String message;
  final String? code;
  
  AuthorizationException(this.message, {this.code});
  
  @override
  String toString() => 'AuthorizationException: $message';
}

class LocationException implements Exception {
  final String message;
  
  LocationException(this.message);
  
  @override
  String toString() => 'LocationException: $message';
}
