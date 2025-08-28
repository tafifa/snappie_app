import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import '../entities/place_entity.dart';

abstract class PlaceRepository {
  /// Get places with pagination and optional filters
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
    bool forceRefresh = false,
  });

  /// Get nearby places based on GPS coordinates
  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? category,
    int limit = 20,
  });

  /// Get place details by ID
  Future<Either<Failure, PlaceEntity>> getPlaceById(int id);

  /// Get available categories
  Future<Either<Failure, List<String>>> getCategories({bool forceRefresh = false});
  
  /// Get favorite places from local storage
  Future<Either<Failure, List<PlaceEntity>>> getFavoritePlaces();
  
  /// Toggle favorite status for a place
  Future<Either<Failure, void>> toggleFavorite(int placeId, bool isFavorite);
  
  /// Clear local cache
  Future<Either<Failure, void>> clearCache();
}
