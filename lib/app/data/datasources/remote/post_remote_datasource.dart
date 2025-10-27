import 'package:dio/dio.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../routes/api_endpoints.dart';
import '../../../core/helpers/api_response_helper.dart';
import '../../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts({int perPage});
  Future<PostModel> getPostById(int id);
  // Future<List<PostModel>> getFeedPosts({int perPage});
  // Future<List<PostModel>> getTrendingPosts({int perPage});
  // Future<PostModel> createPost(PostModel post);
  // Future<PostModel> updatePost(PostModel post);
  // Future<void> deletePost(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient dioClient;
  PostRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<PostModel>> getPosts({int perPage = 10}) async {
    try {
      final queryParams = <String, dynamic>{
        'per_page': perPage,
      };

      final response = await dioClient.dio.get(
        ApiEndpoints.posts,
        queryParameters: queryParams
      );

      return extractApiResponseListData<PostModel>(
        response,
        (json) => PostModel.fromJson(json as Map<String, dynamic>),
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
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.replaceId(ApiEndpoints.articleDetail, '$id'),
      );

      return extractApiResponseData<PostModel>(
        response,
        (json) => PostModel.fromJson(json as Map<String, dynamic>),
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
    }
  }

  // @override
  // Future<PostModel> createPost(PostModel post) async {
  //   try {
  //     final response = await dio.post('/posts', data: post.toJson());
  //     return PostModel.fromJson(response.data);
  //   } catch (e) {
  //     throw Exception('Failed to create post: $e');
  //   }
  // }

  // @override
  // Future<PostModel> updatePost(PostModel post) async {
  //   try {
  //     final response = await dio.put('/posts/${post.id}', data: post.toJson());
  //     return PostModel.fromJson(response.data);
  //   } catch (e) {
  //     throw Exception('Failed to update post: $e');
  //   }
  // }

  // @override
  // Future<void> deletePost(int id) async {
  //   try {
  //     await dio.delete('/posts/$id');
  //   } catch (e) {
  //     throw Exception('Failed to delete post: $e');
  //   }
  // }
}