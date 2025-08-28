import 'package:dio/dio.dart';
import '../../domain/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/articles_model.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<ArticlesModel>> getArticles({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
  });
  
  Future<ArticlesModel> getArticleById(int id);
  Future<List<ArticlesModel>> searchArticles(String query);
  Future<bool> bookmarkArticle(int id);
  Future<List<ArticlesModel>> getBookmarkedArticles();
}

class ArticlesRemoteDataSourceImpl implements ArticlesRemoteDataSource {
  final DioClient dioClient;

  ArticlesRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ArticlesModel>> getArticles({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;

      final response = await dioClient.dio.get(
        '/articles',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> articlesData = response.data['data']['data'] ?? response.data['data'];
        return articlesData.map((json) => ArticlesModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get articles',
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

  @override
  Future<ArticlesModel> getArticleById(int id) async {
    try {
      final response = await dioClient.dio.get('/articles/$id');

      if (response.data['success'] == true) {
        return ArticlesModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get article details',
          response.statusCode ?? 500,
        );
      }
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
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e', 500);
    }
  }

  @override
  Future<List<ArticlesModel>> searchArticles(String query) async {
    try {
      final response = await dioClient.dio.get(
        '/articles',
        queryParameters: {'search': query},
      );

      if (response.data['success'] == true) {
        final List<dynamic> articlesData = response.data['data']['data'] ?? response.data['data'];
        return articlesData.map((json) => ArticlesModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to search articles',
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

  @override
  Future<bool> bookmarkArticle(int id) async {
    try {
      final response = await dioClient.dio.post('/articles/$id/bookmark');

      if (response.data['success'] == true) {
        return true;
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to bookmark article',
          response.statusCode ?? 500,
        );
      }
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
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e', 500);
    }
  }

  @override
  Future<List<ArticlesModel>> getBookmarkedArticles() async {
    try {
      final response = await dioClient.dio.get('/articles/bookmarked');

      if (response.data['success'] == true) {
        final List<dynamic> articlesData = response.data['data']['data'] ?? response.data['data'];
        return articlesData.map((json) => ArticlesModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get bookmarked articles',
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
