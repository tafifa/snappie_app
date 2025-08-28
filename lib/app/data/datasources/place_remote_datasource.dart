import 'package:dio/dio.dart';
import '../../domain/errors/exceptions.dart';
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

      print('🏪 PLACES REQUEST:');
      print('URL: /places');
      print('Query Params: $queryParams');

      final response = await dioClient.dio.get(
        '/places',
        queryParameters: queryParams,
      );

      print('🏪 PLACES RESPONSE:');
      print('Status: ${response.statusCode}');
      print('Success: ${response.data['success']}');
      print('Full Response: ${response.data}');

      if (response.data['success'] == true) {
        // Fixed: Handle backend response format with pagination
        final responseData = response.data['data'];
        print('Response Data Structure: $responseData');
        
        List<dynamic> placesData;
        if (responseData is Map && responseData.containsKey('data')) {
          // Paginated response
          placesData = responseData['data'] ?? [];
          print('Paginated Places Data: $placesData');
        } else if (responseData is List) {
          // Direct array response
          placesData = responseData;
          print('Direct Places Data: $placesData');
        } else {
          placesData = [];
          print('Unknown Places Data Structure');
        }
        
        print('Places Count: ${placesData.length}');
        return placesData.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        print('❌ PLACES ERROR: ${response.data['message']}');
        throw ServerException(
          response.data['message'] ?? 'Failed to get places',
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
  Future<PlaceModel> getPlaceById(int id) async {
    try {
      final response = await dioClient.dio.get('/places/$id');

      if (response.data['success'] == true) {
        return PlaceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get place details',
          response.statusCode ?? 500,
        );
      }
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

  @override
  Future<List<String>> getCategories() async {
    try {
      print('📂 CATEGORIES REQUEST:');
      print('URL: /categories');

      final response = await dioClient.dio.get('/categories');

      print('📂 CATEGORIES RESPONSE:');
      print('Status: ${response.statusCode}');
      print('Success: ${response.data['success']}');
      print('Full Response: ${response.data}');

      if (response.data['success'] == true) {
        // Fixed: Handle backend response format - categories might be in different structure
        final List<dynamic> categoriesData = response.data['data'] ?? [];
        print('Categories Data: $categoriesData');
        print('Categories Count: ${categoriesData.length}');
        
        if (categoriesData.isNotEmpty && categoriesData.first is Map) {
          // If categories are objects with 'value' field (from backend)
          final result = categoriesData.map((cat) => cat['value'] ?? '').where((value) => value.isNotEmpty).cast<String>().toList();
          print('Parsed Categories (Map with value): $result');
          return result;
        } else {
          // If categories are direct strings
          final result = categoriesData.cast<String>();
          print('Parsed Categories (String): $result');
          return result;
        }
      } else {
        print('❌ CATEGORIES ERROR: ${response.data['message']}');
        throw ServerException(
          response.data['message'] ?? 'Failed to get categories',
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
