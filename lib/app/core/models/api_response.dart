// Standard API response model to handle Laravel backend responses
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

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      pagination: json['pagination'],
      errors: json['errors'],
      errorCode: json['error_code'],
      timestamp: json['timestamp'],
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

  // Helper methods
  bool get hasData => data != null;
  bool get hasErrors => errors != null && errors!.isNotEmpty;
  bool get hasPagination => pagination != null;
  
  // Get pagination info
  int? get currentPage => pagination?['current_page'];
  int? get perPage => pagination?['per_page'];
  int? get total => pagination?['total'];
  int? get totalPages => pagination?['total_pages'];
  bool? get hasNextPage => pagination?['has_next_page'];
  
  // Get first error message
  String? get firstErrorMessage {
    if (errors == null || errors!.isEmpty) return null;
    final firstError = errors!.values.first;
    if (firstError is List) {
      return firstError.isNotEmpty ? firstError.first.toString() : null;
    }
    return firstError.toString();
  }
}

// Pagination model for consistent pagination handling
class PaginationInfo {
  final int currentPage;
  final int perPage;
  final int total;
  final int totalPages;
  final bool hasNextPage;

  PaginationInfo({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
      hasNextPage: json['has_next_page'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
      'has_next_page': hasNextPage,
    };
  }
}
