import 'package:dio/dio.dart';
import '../../domain/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/checkin_model.dart';

abstract class CheckinRemoteDataSource {
  Future<CheckinModel> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
  });

  Future<List<CheckinModel>> getCheckinHistory({
    int page,
    int perPage,
    String? status,
  });
}

class CheckinRemoteDataSourceImpl implements CheckinRemoteDataSource {
  final DioClient dioClient;

  CheckinRemoteDataSourceImpl(this.dioClient);

  @override
  Future<CheckinModel> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final data = {
        'place_id': placeId,
        'latitude': latitude,
        'longitude': longitude,
      };

      final response = await dioClient.dio.post(
        '/checkins',
        data: data,
      );

      if (response.data['success'] == true) {
        return CheckinModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to create check-in',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException('Authentication required');
      } else if (e.response?.statusCode == 403) {
        throw AuthorizationException('Access denied');
      } else if (e.response?.statusCode == 422) {
        throw ValidationException(
          e.response?.data['message'] ?? 'Validation failed',
        );
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Network error occurred',
          e.response?.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e', 500);
    }
  }

  @override
  Future<List<CheckinModel>> getCheckinHistory({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      
      if (status != null) queryParams['status'] = status;

      final response = await dioClient.dio.get(
        '/checkins/history',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> checkinsData = response.data['data'];
        return checkinsData.map((json) => CheckinModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get check-in history',
          response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException('Authentication required');
      } else if (e.response?.statusCode == 403) {
        throw AuthorizationException('Access denied');
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Network error occurred',
          e.response?.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e', 500);
    }
  }
}
