import 'package:dio/dio.dart';
import '../utils/api_response.dart';

/// Helper functions for working with ApiResponse in datasources
/// 
/// These helpers reduce boilerplate code when parsing API responses
/// in your remote datasource implementations.

/// Parse a Dio response into ApiResponse with optional data parser
/// 
/// Example:
/// ```dart
/// final response = await dio.get('/profile');
/// final apiResp = parseApiResponse<UserModel>(
///   response,
///   (data) => UserModel.fromJson(data as Map<String, dynamic>),
/// );
/// ```
ApiResponse<T> parseApiResponse<T>(
  Response response, [
  T Function(dynamic)? dataParser,
]) {
  if (response.data is! Map<String, dynamic>) {
    throw ApiResponseParseException(
      'Expected response data to be Map<String, dynamic>, got ${response.data.runtimeType}',
      response.data is Map ? response.data as Map<String, dynamic>? : null,
    );
  }

  return ApiResponse<T>.fromJson(
    response.data as Map<String, dynamic>,
    dataParser,
  );
}

/// Parse a Dio response with list data
/// 
/// Example:
/// ```dart
/// final response = await dio.get('/articles');
/// final apiResp = parseApiResponseList<Article>(
///   response,
///   (item) => Article.fromJson(item as Map<String, dynamic>),
/// );
/// final articles = apiResp.data; // List<Article>
/// ```
ApiResponse parseApiResponseList<T>(
  Response response,
  T Function(dynamic) itemParser,
) {
  if (response.data is! Map<String, dynamic>) {
    throw ApiResponseParseException(
      'Expected response data to be Map<String, dynamic>, got ${response.data.runtimeType}',
      response.data is Map ? response.data as Map<String, dynamic>? : null,
    );
  }

  return ApiResponse.fromJsonList(
    response.data as Map<String, dynamic>,
    itemParser,
  );
}

/// Extract data from ApiResponse or throw exception
/// 
/// This helper validates the response and extracts data in one step.
/// Useful for reducing boilerplate in datasources.
/// 
/// Example:
/// ```dart
/// final response = await dio.get('/profile');
/// final user = extractApiResponseData<UserModel>(
///   response,
///   (data) => UserModel.fromJson(data as Map<String, dynamic>),
/// );
/// // Returns UserModel or throws ApiResponseException
/// ```
T extractApiResponseData<T>(
  Response response,
  T Function(dynamic) dataParser,
) {
  final apiResp = parseApiResponse<T>(response, dataParser);
  
  if (!apiResp.success) {
    throw ApiResponseException(
      message: apiResp.message,
      errors: apiResp.errors,
      errorCode: apiResp.errorCode,
      statusCode: response.statusCode,
    );
  }

  if (!apiResp.hasData) {
    throw ApiResponseException(
      message: 'Response successful but no data received',
      statusCode: response.statusCode,
    );
  }

  return apiResp.data as T;
}

/// Extract list data from ApiResponse or throw exception
/// 
/// Example:
/// ```dart
/// final response = await dio.get('/articles');
/// final articles = extractApiResponseListData<Article>(
///   response,
///   (item) => Article.fromJson(item as Map<String, dynamic>),
/// );
/// // Returns List<Article> or throws ApiResponseException
/// ```
List<T> extractApiResponseListData<T>(
  Response response,
  T Function(dynamic) itemParser,
) {
  final apiResp = parseApiResponseList<T>(response, itemParser);
  
  if (!apiResp.success) {
    throw ApiResponseException(
      message: apiResp.message,
      errors: apiResp.errors,
      errorCode: apiResp.errorCode,
      statusCode: response.statusCode,
    );
  }

  if (!apiResp.hasData) {
    throw ApiResponseException(
      message: 'Response successful but no data received',
      statusCode: response.statusCode,
    );
  }

  final data = apiResp.data;
  if (data is List) {
    return List<T>.from(data);
  }
  
  return [];
}
