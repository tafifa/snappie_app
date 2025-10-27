import 'package:dio/dio.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../routes/api_endpoints.dart';
import '../../../core/helpers/api_response_helper.dart';
import '../../models/articles_model.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<ArticlesModel>> getArticles({
    String? search,
    String? category,
    int? authorId,
    int perPage,
  });
  
  Future<ArticlesModel> getArticleById(int id);
}

class ArticlesRemoteDataSourceImpl implements ArticlesRemoteDataSource {
  final DioClient dioClient;

  ArticlesRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ArticlesModel>> getArticles({
    String? search,
    String? category,
    int? authorId,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'per_page': perPage,
      };
      
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (authorId != null) queryParams['author'] = authorId;

      final response = await dioClient.dio.get(
        ApiEndpoints.articles,
        queryParameters: queryParams,
      );

      print(response.data);

      return extractApiResponseListData<ArticlesModel>(
        response,
        (json) => ArticlesModel.fromJson(json as Map<String, dynamic>),
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
  Future<ArticlesModel> getArticleById(int id) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.replaceId(ApiEndpoints.articleDetail, '$id'),
      );

      return extractApiResponseData<ArticlesModel>(
        response,
        (json) => ArticlesModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException('Authentication required');
      } else if (e.response?.statusCode == 403) {
        throw AuthorizationException('Access denied');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Article not found', 404);
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Network error occurred',
          e.response?.statusCode ?? 500,
        );
      }
    }
  }
}
