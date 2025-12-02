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
  final Map<String, dynamic>? errors;
  
  ValidationException(this.message, {this.errors});
  
  /// Get first error message from any field
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    final firstError = errors!.values.first;
    if (firstError is List) {
      return firstError.isNotEmpty ? firstError.first.toString() : null;
    }
    return firstError.toString();
  }
  
  /// Get error for specific field
  String? getFieldError(String field) {
    if (errors == null) return null;
    final fieldError = errors![field];
    if (fieldError == null) return null;
    if (fieldError is List) {
      return fieldError.isNotEmpty ? fieldError.first.toString() : null;
    }
    return fieldError.toString();
  }
  
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

/// Exception for 409 Conflict - resource already exists or action already performed
class ConflictException implements Exception {
  final String message;
  final String? code;
  
  ConflictException(this.message, {this.code});
  
  @override
  String toString() => 'ConflictException: $message';
}
