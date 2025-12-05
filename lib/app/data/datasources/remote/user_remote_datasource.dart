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
  Future<UserSaved> getUserSaved();
  Future<List<int>> toggleSavedPlace(List<int> placeIds);
  Future<UserSearchResult> searchUsers(String query, {int page = 1, int perPage = 10});
  Future<UserModel> updateUserProfile({
    String? username,
    String? email,
    String? name,
    String? gender,
    String? imageUrl,
    List<String>? foodTypes,
    List<String>? placeValues,
    String? phone,
    DateTime? dateOfBirth,
    String? bio,
    Map<String, dynamic>? privacySettings,
    Map<String, dynamic>? notificationPreferences,
    Map<String, dynamic>? userSettings, // {language, theme}
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
      // Response structure: { data: { user: {...}, stats: {...}, ... } }
      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      // Extract user object from data.user
      final userData = raw['user'] as Map<String, dynamic>?;
      if (userData == null) {
        throw ServerException('User data not found in response', 500);
      }
      final userJson =
          flattenAdditionalInfoForUser(userData, removeContainer: false);
      return UserModel.fromJson(userJson);
    } on ApiResponseException catch (e) {
      if (e.errors != null)
        throw ValidationException(e.message, errors: e.errors);
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
        ApiEndpoints.userById.replaceFirst('{id}', id.toString()),
      );
      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      // Response structure: { data: { user: {...}, ... } } or { data: {...user fields...} }
      // Check if user is nested or flat
      final userData = raw.containsKey('user')
          ? raw['user'] as Map<String, dynamic>
          : raw;
      final userJson =
          flattenAdditionalInfoForUser(userData, removeContainer: false);
      return UserModel.fromJson(userJson);
    } on ApiResponseException catch (e) {
      if (e.errors != null)
        throw ValidationException(e.message, errors: e.errors);
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get user by ID: $e', 500);
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? username,
    String? email,
    String? name,
    String? gender,
    String? imageUrl,
    List<String>? foodTypes,
    List<String>? placeValues,
    String? phone,
    DateTime? dateOfBirth,
    String? bio,
    Map<String, dynamic>? privacySettings,
    Map<String, dynamic>? notificationPreferences,
    Map<String, dynamic>? userSettings,
    Map<String, dynamic>? userNotification,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (username != null) payload['username'] = username;
      if (email != null) payload['email'] = email;
      if (name != null) payload['name'] = name;
      if (gender != null) payload['gender'] = gender;
      if (imageUrl != null) payload['image_url'] = imageUrl;
      if (phone != null) payload['phone'] = phone;
      if (dateOfBirth != null)
        payload['date_of_birth'] = dateOfBirth.toIso8601String();
      if (bio != null) payload['bio'] = bio;
      if (privacySettings != null)
        payload['privacy_settings'] = privacySettings;
      if (notificationPreferences != null)
        payload['notification_preferences'] = notificationPreferences;

      // Keep existing logic for fields not in the flat update spec but present in code?
      // The spec for update profile does NOT include food_type/place_value/user_settings/user_notification at top level.
      // But the previous code put them in additional_info.
      // If I strictly follow "Flatten body fields", I should put them at top level IF they are in the spec.
      // But they are NOT in the spec for Update Profile.
      // I will assume the user wants the code to match the spec, so I should probably NOT send them if they aren't in the spec?
      // But that might break app functionality if the backend actually supports them.
      // However, the mismatch said "Flat body fields (gender, bio, etc.) | Nested in additional_info".
      // It didn't mention food_type.
      // I will keep the others in additional_info if they were there, OR I will remove them if I want to be 100% spec compliant.
      // Given the instruction "move gender, bio, etc. inside additional_info map" (which I interpreted as "flatten them" based on the mismatch list),
      // I will assume the goal is to match the spec.
      // I will leave the other fields out of the payload if they are not in the spec, OR put them in additional_info if the backend supports it loosely.
      // But wait, the previous code had them.
      // I'll try to keep them but maybe flattened if possible? No, spec doesn't have them.
      // I'll just leave them in additional_info for now as "extra" data, but flatten the ones that ARE in the spec.

      final additional = <String, dynamic>{};

      final prefs = <String, dynamic>{};
      if (foodTypes != null) prefs['food_type'] = foodTypes;
      if (placeValues != null) prefs['place_value'] = placeValues;
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
      // Response structure: { data: { user: {...}, ... } } or { data: {...user fields...} }
      // Check if user is nested or flat
      final userData = raw.containsKey('user')
          ? raw['user'] as Map<String, dynamic>
          : raw;
      final userJson =
          flattenAdditionalInfoForUser(userData, removeContainer: false);
      return UserModel.fromJson(userJson);
    } on ApiResponseException catch (e) {
      if (e.errors != null)
        throw ValidationException(e.message, errors: e.errors);
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to update profile: $e', 500);
    }
  }

  @override
  Future<UserSaved> getUserSaved() async {
    try {
      final resp = await dioClient.dio.get(ApiEndpoints.userSaved);
      print('⭐ getUserSaved response: $resp');
      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      return UserSaved.fromJson(raw);
    } on ApiResponseException catch (e) {
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to get user saved: $e', 500);
    }
  }

  @override
  Future<List<int>> toggleSavedPlace(List<int> placeIds) async {
    try {
      final resp = await dioClient.dio.post(
        ApiEndpoints.userSaved,
        data: {'saved_places': placeIds},
      );
      print('⭐ toggleSavedPlace response: $resp');
      // Response returns list of saved place IDs
      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      final savedPlaces = raw['saved_places'] as List<dynamic>?;
      return savedPlaces?.map((e) => e as int).toList() ?? [];
    } on ApiResponseException catch (e) {
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to toggle saved place: $e', 500);
    }
  }

  @override
  Future<UserSearchResult> searchUsers(String query, {int page = 1, int perPage = 10}) async {
    try {
      final resp = await dioClient.dio.get(
        ApiEndpoints.usersSearch,
        queryParameters: {
          'q': query,
          'page': page,
          'per_page': perPage,
        },
      );
      final raw = extractApiResponseData<Map<String, dynamic>>(
        resp,
        (json) => Map<String, dynamic>.from(json as Map<String, dynamic>),
      );
      return UserSearchResult.fromJson(raw);
    } on ApiResponseException catch (e) {
      throw ServerException(e.message, e.statusCode ?? 500);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Failed to search users: $e', 500);
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
