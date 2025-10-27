import 'package:dio/dio.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../routes/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/helpers/api_response_helper.dart';
import '../../../core/helpers/json_mapping_helper.dart';
import '../../../data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> getUserById(int id);
  Future<UserModel> updateUserProfile({
    String? name,
    String? gender,
    String? imageUrl,
    List<String>? foodTypes,
    List<String>? placeValues,
    String? phone,
    DateTime? dateOfBirth,
    String? bio,
    Map<String, dynamic>? userSettings,     // {language, theme}
    Map<String, dynamic>? userNotification, // {push_notification}
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;
  UserRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final resp = await dioClient.dio.get(ApiEndpoints.profile);
      // Helper kita langsung mengembalikan bagian "data" → Map<String,dynamic>
      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      final userJson = flattenAdditionalInfoForUser(raw, removeContainer: false);
      return UserModel.fromJson(userJson);
    } on ApiResponseException catch (e) {
      if (e.errors != null) throw ValidationException(e.message, errors: e.errors);
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get profile: $e', 500);
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final resp = await dioClient.dio.get(
        ApiEndpoints.userById.replaceFirst(':id', id.toString()),
      );
      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      final userJson = flattenAdditionalInfoForUser(raw, removeContainer: false);
      return UserModel.fromJson(userJson);
    } on ApiResponseException catch (e) {
      if (e.errors != null) throw ValidationException(e.message, errors: e.errors);
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get user by ID: $e', 500);
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? name,
    String? gender,
    String? imageUrl,
    List<String>? foodTypes,
    List<String>? placeValues,
    String? phone,
    DateTime? dateOfBirth,
    String? bio,
    Map<String, dynamic>? userSettings,
    Map<String, dynamic>? userNotification,
  }) async {
    try {
      // Build payload sesuai kontrak API (wrap kembali ke additional_info)
      final payload = <String, dynamic>{};
      if (name != null) payload['name'] = name;
      if (imageUrl != null) payload['image_url'] = imageUrl;

      final additional = <String, dynamic>{};

      final detail = <String, dynamic>{};
      if (gender != null) detail['gender'] = gender;
      if (bio != null) detail['bio'] = bio;
      if (phone != null) detail['phone'] = phone;
      if (dateOfBirth != null) detail['date_of_birth'] = dateOfBirth.toIso8601String();
      if (detail.isNotEmpty) additional['user_detail'] = detail;

      final prefs = <String, dynamic>{};
      if (foodTypes != null) prefs['food_type'] = foodTypes;
      if (placeValues != null) prefs['place_value'] = placeValues; // singular sesuai API
      if (prefs.isNotEmpty) additional['user_preferences'] = prefs;

      if (userSettings != null && userSettings.isNotEmpty) {
        additional['user_settings'] = userSettings;
      }
      if (userNotification != null && userNotification.isNotEmpty) {
        additional['user_notification'] = userNotification;
      }

      if (additional.isNotEmpty) payload['additional_info'] = additional;

      final resp = await dioClient.dio.post(
        ApiEndpoints.updateProfile,
        data: payload,
      );

      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      final userJson = flattenAdditionalInfoForUser(raw, removeContainer: false);
      return UserModel.fromJson(userJson);
    } on ApiResponseException catch (e) {
      if (e.errors != null) throw ValidationException(e.message, errors: e.errors);
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to update profile: $e', 500);
    }
  }

  Exception _handleDioException(DioException e) {
    final code = e.response?.statusCode ?? 500;
    if (code == 401) return AuthenticationException('Authentication failed');
    if (code == 403) return AuthorizationException('Access denied');
    if (code == 422) {
      return ValidationException(
        'Validation failed',
        errors: e.response?.data is Map ? e.response?.data['errors'] : null,
      );
    }
    return ServerException(
      (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response?.data['message']
          : 'Server error',
      code,
    );
  }
}
