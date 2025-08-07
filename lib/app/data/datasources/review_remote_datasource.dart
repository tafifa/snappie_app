import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewModel> createReview({
    required int placeId,
    required int vote,
    required String content,
    List<String>? imageUrls,
  });

  Future<List<ReviewModel>> getReviews({
    int page = 1,
    int perPage = 20,
    int? placeId,
    int? userId,
    String? status,
    String? sortBy,
    String? sortOrder,
  });
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final DioClient dioClient;

  ReviewRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ReviewModel> createReview({
    required int placeId,
    required int vote,
    required String content,
    List<String>? imageUrls,
  }) async {
    try {
      final data = <String, dynamic>{
        'place_id': placeId,
        'vote': vote,
        'content': content,
      };
      
      if (imageUrls != null && imageUrls.isNotEmpty) {
        data['image_urls'] = imageUrls;
      }

      final response = await dioClient.dio.post(
        '/reviews',
        data: data,
      );

      if (response.data['success'] == true) {
        return ReviewModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to create review',
          statusCode: response.statusCode,
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
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getReviews({
    int page = 1,
    int perPage = 20,
    int? placeId,
    int? userId,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      
      if (placeId != null) queryParams['place_id'] = placeId;
      if (userId != null) queryParams['user_id'] = userId;
      if (status != null) queryParams['status'] = status;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;

      final response = await dioClient.dio.get(
        '/reviews',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> reviewsData = response.data['data'];
        return reviewsData.map((json) => ReviewModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get reviews',
          statusCode: response.statusCode,
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
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }
}