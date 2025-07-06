import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getCurrentUser();
  Future<UserModel> getUserById(String id);
  Future<List<UserModel>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  });
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;
  
  UserRemoteDataSourceImpl(this.dioClient);
  
  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.dio.get('/user/me');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get current user: $e');
    }
  }
  
  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await dioClient.dio.get('/users/$id');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get user: $e');
    }
  }
  
  @override
  Future<List<UserModel>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      };
      
      final response = await dioClient.dio.get(
        '/users',
        queryParameters: queryParams,
      );
      
      final List<dynamic> usersJson = response.data['data'];
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get users: $e');
    }
  }
  
  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await dioClient.dio.put(
        '/users/${user.id}',
        data: user.toJson(),
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to update user: $e');
    }
  }
  
  @override
  Future<void> deleteUser(String id) async {
    try {
      await dioClient.dio.delete('/users/$id');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to delete user: $e');
    }
  }
  
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to login: $e');
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await dioClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to logout: $e');
    }
  }
  
  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to register: $e');
    }
  }
  
  @override
  Future<void> forgotPassword(String email) async {
    try {
      await dioClient.dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to send forgot password email: $e');
    }
  }
  
  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await dioClient.dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to reset password: $e');
    }
  }
  
  Exception _handleDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      return const AuthenticationException('Authentication failed');
    } else if (e.response?.statusCode == 403) {
      return const AuthorizationException('Access denied');
    } else if (e.response?.statusCode == 422) {
      return ValidationException(
        'Validation failed',
        errors: e.response?.data['errors'],
      );
    } else {
      return ServerException(
        e.response?.data['message'] ?? 'Server error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}