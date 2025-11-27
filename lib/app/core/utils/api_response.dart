/// Standard API response model to handle Laravel backend responses
//
// This file provides a standardized way to parse and handle API responses
// from Laravel backends, including success/error states, data payload,
// validation errors, and pagination metadata.
//
// USAGE EXAMPLES:
//
// 1. Simple parsing (data remains dynamic):
//    final apiResp = ApiResponse.fromJson(responseData);
//    if (apiResp.success) {
//      final user = UserModel.fromJson(apiResp.data);
//    }
//
// 2. Type-safe parsing with parser function:
//    final apiResp = ApiResponse<UserModel>.fromJson(
//      responseData,
//      (data) => UserModel.fromJson(data as Map<String, dynamic>),
//    );
//    final user = apiResp.data; // Already UserModel!
//
// 3. Parse list of items:
//    final apiResp = ApiResponse<List<Article>>.fromJsonList(
//      responseData,
//      (item) => Article.fromJson(item as Map<String, dynamic>),
//    );
//    final articles = apiResp.data; // List<Article>
//
// 4. Error handling:
//    if (apiResp.hasErrors) {
//      print(apiResp.firstErrorMessage);
//      print(apiResp.getAllErrorMessages());
//      print(apiResp.getFieldError('email'));
//    }
//
// 5. Pagination:
//    if (apiResp.hasPagination) {
//      final pageInfo = apiResp.paginationInfo;
//      print('Page ${pageInfo?.currentPage} of ${pageInfo?.totalPages}');
//    }
//
// 6. Throw exception on failure:
//    apiResp.throwIfNotSuccess(); // Throws ApiResponseException if failed
/// 
/// This class wraps API responses with consistent structure for:
/// - Success/failure indication
/// - Data payload (generic type T)
/// - Error messages and validation errors
/// - Pagination metadata
/// 
/// Example usage:
/// ```dart
/// // Simple parsing (data remains dynamic)
/// final apiResp = ApiResponse.fromJson(responseData);
/// 
/// // With type-safe data parsing
/// final apiResp = ApiResponse<UserModel>.fromJson(
///   responseData,
///   (data) => UserModel.fromJson(data as Map<String, dynamic>),
/// );
/// 
/// // Parse list of items
/// final apiResp = ApiResponse<List<Article>>.fromJsonList(
///   responseData,
///   (item) => Article.fromJson(item as Map<String, dynamic>),
/// );
/// ```
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? pagination;
  final Map<String, dynamic>? errors;
  final String? errorCode;
  final String? timestamp;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
    this.errors,
    this.errorCode,
    this.timestamp,
  });

  /// Parse JSON response without type-safe data parsing
  /// Data will remain as dynamic and needs manual parsing
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic)? dataParser,
  ]) {
    final rawData = json['data'];
    T? parsedData;

    if (rawData != null && dataParser != null) {
      try {
        parsedData = dataParser(rawData);
      } catch (e) {
        throw ApiResponseParseException(
          'Failed to parse data field: $e',
          json,
        );
      }
    } else {
      parsedData = rawData as T?;
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
      pagination: json['pagination'] as Map<String, dynamic>?,
      errors: json['errors'] as Map<String, dynamic>?,
      errorCode: json['error_code'] as String?,
      timestamp: json['timestamp'] as String?,
    );
  }

  /// Parse JSON response with list data
  /// 
  /// Supports two formats:
  /// 1. Simple list: { "data": [...] }
  /// 2. Laravel paginated: { "data": { "data": [...], "current_page": 1, ... } }
  /// 
  /// Example:
  /// ```dart
  /// final response = ApiResponse<List<Article>>.fromJsonList(
  ///   jsonData,
  ///   (item) => Article.fromJson(item),
  /// );
  /// ```
  factory ApiResponse.fromJsonList(
    Map<String, dynamic> json,
    T Function(dynamic) itemParser,
  ) {
    final rawData = json['data'];
    List<T>? parsedList;
    Map<String, dynamic>? paginationData;

    if (rawData != null) {
      // Check if it's Laravel pagination format (data is a Map with nested 'data')
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        // Laravel pagination format
        final nestedData = rawData['data'];
        
        if (nestedData is! List) {
          throw ApiResponseParseException(
            'Expected nested data to be a List, got ${nestedData.runtimeType}',
            json,
          );
        }

        try {
          parsedList = nestedData.map((item) => itemParser(item)).toList() as List<T>?;
        } catch (e) {
          throw ApiResponseParseException(
            'Failed to parse list items: $e',
            json,
          );
        }

        // Extract pagination info from rawData (excluding 'data' key)
        paginationData = Map<String, dynamic>.from(rawData)..remove('data');
      } 
      // Support format where list is under 'items'
      else if (rawData is Map<String, dynamic> && rawData.containsKey('items')) {
        final nestedItems = rawData['items'];

        if (nestedItems is! List) {
          throw ApiResponseParseException(
            'Expected nested items to be a List, got ${nestedItems.runtimeType}',
            json,
          );
        }

        try {
          parsedList = nestedItems.map((item) => itemParser(item)).toList() as List<T>?;
        } catch (e) {
          throw ApiResponseParseException(
            'Failed to parse list items: $e',
            json,
          );
        }

        paginationData = Map<String, dynamic>.from(rawData)..remove('items');
      } 
      // Simple list format
      else if (rawData is List) {
        try {
          parsedList = rawData.map((item) => itemParser(item)).toList() as List<T>?;
        } catch (e) {
          throw ApiResponseParseException(
            'Failed to parse list items: $e',
            json,
          );
        }
      } else {
        throw ApiResponseParseException(
          'Expected data to be a List or paginated Map, got ${rawData.runtimeType}',
          json,
        );
      }
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedList as T?,
      pagination: paginationData ?? json['pagination'] as Map<String, dynamic>?,
      errors: json['errors'] as Map<String, dynamic>?,
      errorCode: json['error_code'] as String?,
      timestamp: json['timestamp'] as String?,
    );
  }

  /// Create a success response manually (useful for testing)
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    Map<String, dynamic>? pagination,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      pagination: pagination,
    );
  }

  /// Create an error response manually (useful for testing)
  factory ApiResponse.error({
    required String message,
    Map<String, dynamic>? errors,
    String? errorCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      errorCode: errorCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'pagination': pagination,
      'errors': errors,
      'error_code': errorCode,
      'timestamp': timestamp,
    };
  }

  /// Create a copy of this ApiResponse with modified fields
  ApiResponse<T> copyWith({
    bool? success,
    String? message,
    T? data,
    Map<String, dynamic>? pagination,
    Map<String, dynamic>? errors,
    String? errorCode,
    String? timestamp,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
      errors: errors ?? this.errors,
      errorCode: errorCode ?? this.errorCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helper methods
  
  /// Check if response has valid data
  bool get hasData => data != null;
  
  /// Check if response contains validation or server errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;
  
  /// Check if response includes pagination metadata
  bool get hasPagination => pagination != null;
  
  /// Check if the request was successful and has data
  bool get isSuccessWithData => success && hasData;
  
  // Pagination helpers (Laravel format)
  
  /// Get current page number from pagination metadata
  int? get currentPage => pagination?['current_page'] as int?;
  
  /// Get items per page from pagination metadata
  int? get perPage => pagination?['per_page'] as int?;
  
  /// Get total number of items from pagination metadata
  int? get total => pagination?['total'] as int?;
  
  /// Get last page number (total pages) from pagination metadata
  int? get lastPage => pagination?['last_page'] as int?;
  
  /// Get total number of pages (alias for lastPage)
  int? get totalPages => lastPage;
  
  /// Check if there's a next page available
  bool get hasNextPage => pagination?['next_page_url'] != null;
  
  /// Check if there's a previous page available
  bool get hasPrevPage => pagination?['prev_page_url'] != null;
  
  /// Get next page URL
  String? get nextPageUrl => pagination?['next_page_url'] as String?;
  
  /// Get previous page URL
  String? get prevPageUrl => pagination?['prev_page_url'] as String?;
  
  /// Get pagination info as PaginationInfo object
  PaginationInfo? get paginationInfo {
    if (!hasPagination) return null;
    return PaginationInfo.fromJson(pagination!);
  }
  
  // Error helpers
  
  /// Get the first error message from errors map
  /// Useful for displaying a single error to user
  String? get firstErrorMessage {
    if (errors == null || errors!.isEmpty) return null;
    final firstError = errors!.values.first;
    if (firstError is List) {
      return firstError.isNotEmpty ? firstError.first.toString() : null;
    }
    return firstError.toString();
  }
  
  /// Get error message for a specific field
  /// 
  /// Example:
  /// ```dart
  /// final emailError = apiResp.getFieldError('email');
  /// ```
  String? getFieldError(String fieldName) {
    if (errors == null) return null;
    final fieldError = errors![fieldName];
    if (fieldError == null) return null;
    
    if (fieldError is List) {
      return fieldError.isNotEmpty ? fieldError.first.toString() : null;
    }
    return fieldError.toString();
  }
  
  /// Get all error messages as a flat list
  /// 
  /// Example:
  /// ```dart
  /// final allErrors = apiResp.getAllErrorMessages();
  /// // ['Email is required', 'Password is too short']
  /// ```
  List<String> getAllErrorMessages() {
    if (errors == null || errors!.isEmpty) return [];
    
    final messages = <String>[];
    for (final error in errors!.values) {
      if (error is List) {
        messages.addAll(error.map((e) => e.toString()));
      } else {
        messages.add(error.toString());
      }
    }
    return messages;
  }
  
  /// Get all errors grouped by field name
  /// 
  /// Example:
  /// ```dart
  /// final errorsByField = apiResp.getErrorsByField();
  /// // {'email': ['Email is required'], 'password': ['Too short']}
  /// ```
  Map<String, List<String>> getErrorsByField() {
    if (errors == null || errors!.isEmpty) return {};
    
    final errorsByField = <String, List<String>>{};
    errors!.forEach((field, error) {
      if (error is List) {
        errorsByField[field] = error.map((e) => e.toString()).toList();
      } else {
        errorsByField[field] = [error.toString()];
      }
    });
    return errorsByField;
  }
  
  /// Throw an exception if response is not successful
  /// 
  /// Example:
  /// ```dart
  /// apiResp.throwIfNotSuccess(); // throws ApiResponseException if failed
  /// ```
  void throwIfNotSuccess() {
    if (!success) {
      throw ApiResponseException(
        message: message,
        errors: errors,
        errorCode: errorCode,
        statusCode: null,
      );
    }
  }
  
  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, '
        'hasData: $hasData, hasErrors: $hasErrors, hasPagination: $hasPagination)';
  }
}

/// Exception thrown when API response parsing fails
class ApiResponseParseException implements Exception {
  final String message;
  final Map<String, dynamic>? rawJson;
  
  ApiResponseParseException(this.message, [this.rawJson]);
  
  @override
  String toString() => 'ApiResponseParseException: $message';
}

/// Exception thrown when API response indicates failure
class ApiResponseException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  final String? errorCode;
  final int? statusCode;
  
  ApiResponseException({
    required this.message,
    this.errors,
    this.errorCode,
    this.statusCode,
  });
  
  /// Get first error message
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    final firstError = errors!.values.first;
    if (firstError is List) {
      return firstError.isNotEmpty ? firstError.first.toString() : null;
    }
    return firstError.toString();
  }
  
  @override
  String toString() {
    return 'ApiResponseException: $message${errorCode != null ? ' ($errorCode)' : ''}';
  }
}

// Pagination model for Laravel LengthAwarePaginator format
class PaginationInfo {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? from;
  final int? to;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String? path;
  final List<Map<String, dynamic>>? links;

  PaginationInfo({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.from,
    this.to,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
    this.links,
  });

  /// Check if there's a next page
  bool get hasNextPage => nextPageUrl != null;
  
  /// Check if there's a previous page
  bool get hasPrevPage => prevPageUrl != null;
  
  /// Check if this is the first page
  bool get isFirstPage => currentPage == 1;
  
  /// Check if this is the last page
  bool get isLastPage => currentPage == lastPage;
  
  /// Get total pages (alias for lastPage)
  int get totalPages => lastPage;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      from: json['from'] as int?,
      to: json['to'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      path: json['path'] as String?,
      links: json['links'] != null 
          ? List<Map<String, dynamic>>.from(json['links'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'from': from,
      'to': to,
      'first_page_url': firstPageUrl,
      'last_page_url': lastPageUrl,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
      'path': path,
      'links': links,
    };
  }
  
  @override
  String toString() {
    return 'PaginationInfo(page: $currentPage/$lastPage, total: $total, hasNext: $hasNextPage)';
  }
}
