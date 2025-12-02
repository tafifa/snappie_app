import 'package:dio/dio.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../routes/api_endpoints.dart';
import '../../../core/helpers/api_response_helper.dart';
import '../../models/checkin_model.dart';

abstract class CheckinRemoteDataSource {
  Future<CheckinModel> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
    String? imageUrl,
    Map<String, dynamic>? additionalInfo,
  });
  
  Future<List<CheckinModel>> getCheckinsByPlaceId(int placeId, {int page = 1, int perPage = 20});
}

class CheckinRemoteDataSourceImpl implements CheckinRemoteDataSource {
  final DioClient dioClient;

  CheckinRemoteDataSourceImpl(this.dioClient);

  @override
  Future<CheckinModel> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
    String? imageUrl,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      final payload = <String, dynamic>{
        'place_id': placeId,
        'latitude': latitude,
        'longitude': longitude,
      };

      if (imageUrl != null) {
        payload['image_url'] = imageUrl;
      }

      if (additionalInfo != null && additionalInfo.isNotEmpty) {
        payload['additional_info'] = additionalInfo;
      }

      print('⭐ createCheckin payload: $payload');

      final response = await dioClient.dio.post(
        ApiEndpoints.createCheckin,
        data: payload,
      );

      print('⭐ createCheckin response: $response');

      return extractApiResponseData<CheckinModel>(
        response,
        (json) => CheckinModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException('Authentication required');
      } else if (e.response?.statusCode == 403) {
        throw AuthorizationException('Access denied');
      } else if (e.response?.statusCode == 409) {
        // Conflict - already checked in
        final errorMsg = e.response?.data['error'] ?? 
            e.response?.data['message'] ?? 
            'You have already checked in at this place';
        throw ConflictException(errorMsg);
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
  Future<List<CheckinModel>> getCheckinsByPlaceId(int placeId, {int page = 1, int perPage = 20}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.replaceId(ApiEndpoints.placeCheckins, '$placeId'),
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      return extractApiResponseListData<CheckinModel>(
        response,
        (json) => CheckinModel.fromJson(json as Map<String, dynamic>),
      );
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
