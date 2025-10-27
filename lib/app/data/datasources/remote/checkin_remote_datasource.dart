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
    String? imageUrl,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      final payload = {
        'place_id': placeId,
        'latitude': latitude,
        'longitude': longitude,
        if (imageUrl != null) 'image_url': imageUrl,
      };

      final response = await dioClient.dio.post(
        ApiEndpoints.createCheckin,
        data: payload,
      );

      return extractApiResponseData<CheckinModel>(
        response,
        (json) => CheckinModel.fromJson(json as Map<String, dynamic>),
      );
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
}
