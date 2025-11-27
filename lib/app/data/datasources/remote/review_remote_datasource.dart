import 'package:dio/dio.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../routes/api_endpoints.dart';
import '../../../core/helpers/api_response_helper.dart';
import '../../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewModel> createReview({
    required int placeId,
    required String content,
    required int rating,
    required Map<String, dynamic> additionalInfo,
    List<String>? imageUrls,
  });

  Future<List<ReviewModel>> getPlaceReviews(int placeId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final DioClient dioClient;

  ReviewRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ReviewModel> createReview({
    required int placeId,
    required String content,
    required int rating,
    required Map<String, dynamic> additionalInfo,
    List<String>? imageUrls,
  }) async {
    try {
      final payload = <String, dynamic>{
        'place_id': placeId,
        'content': content,
        'rating': rating,
        'additional_info': additionalInfo,
      };

      if (imageUrls != null && imageUrls.isNotEmpty) {
        payload['image_urls'] = imageUrls;
      }

      final response = await dioClient.dio.post(
        ApiEndpoints.reviewPlace,
        data: payload,
      );

      return extractApiResponseData<ReviewModel>(
        response,
        (json) => ReviewModel.fromJson(json as Map<String, dynamic>),
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

  @override
  Future<List<ReviewModel>> getPlaceReviews(int placeId) async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.replaceId(ApiEndpoints.placeReviews, '$placeId'));

      return extractApiResponseListData<ReviewModel>(
        response,
        (json) => ReviewModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException('Authentication required');
      } else if (e.response?.statusCode == 403) {
        throw AuthorizationException('Access denied');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Place not found', 404);
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
