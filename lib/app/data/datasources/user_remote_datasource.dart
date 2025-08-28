import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../domain/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

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

  Future<UserModel> getProfile();

  Future<UserModel> updateProfile({
    required String name,
    String? avatar,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<List<UserModel>> getUsers({
    int page,
    int perPage,
    String? search,
    String? role,
  });

  Future<UserModel> getUserById(int id);

  Future<void> deleteUser(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
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
      throw ServerException('Failed to login: $e', 500);
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await dioClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to logout: $e', 500);
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
      throw ServerException('Failed to register: $e', 500);
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
      throw ServerException('Failed to send forgot password email: $e', 500);
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
      throw ServerException('Failed to reset password: $e', 500);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dioClient.dio.get('/user/profile');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get profile: $e', 500);
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? avatar,
  }) async {
    try {
      final data = <String, dynamic>{'name': name};
      if (avatar != null) data['avatar'] = avatar;

      final response = await dioClient.dio.put(
        '/user/profile',
        data: data,
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to update profile: $e', 500);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await dioClient.dio.put(
        '/user/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to change password: $e', 500);
    }
  }

  @override
  Future<List<UserModel>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? role,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      
      if (search != null) queryParams['search'] = search;
      if (role != null) queryParams['role'] = role;

      final response = await dioClient.dio.get(
        '/users',
        queryParameters: queryParams,
      );

      final List<dynamic> usersData = response.data['data'];
      return usersData.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get users: $e', 500);
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await dioClient.dio.get('/users/$id');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get user: $e', 500);
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await dioClient.dio.delete('/users/$id');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to delete user: $e', 500);
    }
  }
  
  Exception _handleDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      return AuthenticationException('Authentication failed');
    } else if (e.response?.statusCode == 403) {
      return AuthorizationException('Access denied');
    } else if (e.response?.statusCode == 422) {
      return ValidationException(
        'Validation failed',
        errors: e.response?.data['errors'],
      );
    } else {
      return ServerException(
        e.response?.data['message'] ?? 'Server error',
        e.response?.statusCode ?? 500,
      );
    }
  }
}
