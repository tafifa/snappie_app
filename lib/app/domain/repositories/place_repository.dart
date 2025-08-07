import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/place_entity.dart';

abstract class PlaceRepository {
  /// Get places with pagination and optional filters
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
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
  Future<Either<Failure, List<String>>> getCategories();
}