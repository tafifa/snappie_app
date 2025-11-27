import 'package:snappie_app/app/core/network/network_info.dart';

import '../../core/errors/exceptions.dart';
import '../datasources/remote/place_remote_datasource.dart';
import '../models/place_model.dart';

/// Place Repository - No domain layer, direct Model return
/// Throws exceptions instead of returning Either<Failure, T>
class PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlaceRepository({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Get places with pagination and optional filters
  /// Returns cached data if available and not expired (< 15 minutes)
  /// Throws: [ServerException], [NetworkException], [CacheException]
  Future<List<PlaceModel>> getPlaces({
    List<String>? foodTypes,
    List<String>? placeValues,
    int perPage = 20,
    int page = 1,
    String? search,
    double? minRating,
    double? latitude,
    double? longitude,
    double? radius,
    bool? popular,
    bool? partner,
    bool? activeOnly,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    final places = await remoteDataSource.getPlaces(
      foodTypes: foodTypes,
      placeValues: placeValues,
      perPage: perPage,
      page: page,
      search: search,
      minRating: minRating,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      popular: popular,
      partner: partner,
      activeOnly: activeOnly,
    );

    return places;
  }

  /// Get place details by ID
  /// Throws: [ServerException], [NetworkException]
  Future<PlaceModel> getPlaceById(int id) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    final place = await remoteDataSource.getPlaceById(id);

    return place;
  }
}
