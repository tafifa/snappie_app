import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../services/auth_service.dart';
import '../constants/app_constants.dart';

class DioClient {
  static const String skipAuthRefreshKey = 'skip_auth_refresh';
  static const String retryAttemptedKey = 'token_retry_attempted';

  late Dio _dio;
  
  DioClient() {
    _dio = Dio();
    _setupDio();
  }
  
  void _setupDio() {
    // Base options
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    
    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(_dio),
    ]);
  }
  
  Dio get dio => _dio;
}

// Auth interceptor to add auth headers
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[DioClient.skipAuthRefreshKey] == true) {
      handler.next(options);
      return;
    }

    try {
      final authService = getx.Get.find<AuthService>();
      final authHeaders = authService.getAuthHeaders();
      
      // Add auth headers to request
      options.headers.addAll(authHeaders);
    } catch (e) {
      // AuthService not available, continue without auth
      print('AuthService not available: $e');
    }
    
    handler.next(options);
  }
}

// Logging interceptor
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Error: ${err.message}');
    handler.next(err);
  }
}

// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  _ErrorInterceptor(this._dio);

  final Dio _dio;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final shouldSkipRefresh =
        requestOptions.extra[DioClient.skipAuthRefreshKey] == true;
    final hasRetried =
        requestOptions.extra[DioClient.retryAttemptedKey] == true;

    if (_isUnauthorized(err) && !shouldSkipRefresh && !hasRetried) {
      final authService = _tryGetAuthService();
      if (authService != null) {
        final refreshed = await authService.refreshToken();
        if (refreshed && authService.token != null) {
          requestOptions.extra[DioClient.retryAttemptedKey] = true;
          requestOptions.headers['Authorization'] =
              authService.getAuthHeaders()['Authorization'];
          try {
            final response = await _dio.fetch(requestOptions);
            handler.resolve(response);
            return;
          } on DioException catch (retryError) {
            handler.next(retryError);
            return;
          }
        } else {
          await authService.logout();
        }
      }
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        print('Timeout error: ${err.message}');
        break;
      case DioExceptionType.badResponse:
        print('Bad response: ${err.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        print('Request cancelled');
        break;
      default:
        print('Network error: ${err.message}');
    }
    
    handler.next(err);
  }

  bool _isUnauthorized(DioException err) =>
      err.response?.statusCode == 401 || err.response?.statusCode == 403;

  AuthService? _tryGetAuthService() {
    if (getx.Get.isRegistered<AuthService>()) {
      return getx.Get.find<AuthService>();
    }
    return null;
  }
}
