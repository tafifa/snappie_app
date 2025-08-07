import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/place_model.dart';

abstract class PlaceRemoteDataSource {
  Future<List<PlaceModel>> getPlaces({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
  });

  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? category,
    int limit = 20,
  });

  Future<PlaceModel> getPlaceById(int id);
  Future<List<String>> getCategories();
}

class PlaceRemoteDataSourceImpl implements PlaceRemoteDataSource {
  final DioClient dioClient;

  PlaceRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<PlaceModel>> getPlaces({
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
        '/places',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> placesData = response.data['data'];
        return placesData.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get places',
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

  @override
  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? category,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'limit': limit,
      };
      
      if (category != null) queryParams['category'] = category;

      final response = await dioClient.dio.get(
        '/places/nearby',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> placesData = response.data['data'];
        return placesData.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get nearby places',
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

  @override
  Future<PlaceModel> getPlaceById(int id) async {
    try {
      final response = await dioClient.dio.get('/places/$id');

      if (response.data['success'] == true) {
        return PlaceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get place details',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException('Authentication required');
      } else if (e.response?.statusCode == 403) {
        throw AuthorizationException('Access denied');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Place not found', statusCode: 404);
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
  Future<List<String>> getCategories() async {
    try {
      final response = await dioClient.dio.get('/categories');

      if (response.data['success'] == true) {
        final List<dynamic> categoriesData = response.data['data'];
        return categoriesData.cast<String>();
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get categories',
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