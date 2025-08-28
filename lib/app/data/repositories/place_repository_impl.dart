import 'package:dartz/dartz.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_remote_datasource.dart';
import '../datasources/place_local_datasource.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;
  final PlaceLocalDataSource localDataSource;
  
  PlaceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
    bool forceRefresh = false,
  }) async {
    try {
      // Check if we should use cached data
      if (!forceRefresh && page == 1) {
        final hasCachedData = await localDataSource.hasCachedData();
        final lastSync = await localDataSource.getLastSyncTime();
        
        if (hasCachedData && lastSync != null) {
          final cacheAge = DateTime.now().difference(lastSync);
          
          // Use cache if it's less than 15 minutes old
          if (cacheAge.inMinutes < 15) {
            print('📱 Using cached data (age: ${cacheAge.inMinutes} minutes)');
            final cachedPlaces = await localDataSource.getPlaces(
              category: category,
              search: search,
            );
            
            if (cachedPlaces.isNotEmpty) {
              return Right(cachedPlaces);
            }
          }
        }
      }
      
      // Fetch from remote API
      print('🌐 Fetching places from API...');
      final remotePlaces = await remoteDataSource.getPlaces(
        page: page,
        perPage: perPage,
        category: category,
        search: search,
      );
      
      // Save to local database (only for first page)
      if (page == 1) {
        final entities = remotePlaces.map((place) => place.toEntity()).toList();
        await localDataSource.savePlaces(entities);
      }
      
      final entities = remotePlaces.map((place) => place.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      print('❌ Error in repository: $e');
      
      // Try to get cached data as fallback
      try {
        final cachedPlaces = await localDataSource.getPlaces(
          category: category,
          search: search,
        );
        
        if (cachedPlaces.isNotEmpty) {
          print('📱 Using cached data as fallback');
          return Right(cachedPlaces);
        }
      } catch (cacheError) {
        print('❌ Cache fallback failed: $cacheError');
      }
      
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? category,
    int limit = 20,
  }) async {
    try {
      final places = await remoteDataSource.getNearbyPlaces(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        category: category,
        limit: limit,
      );
      
      final entities = places.map((place) => place.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, PlaceEntity>> getPlaceById(int id) async {
    try {
      final place = await remoteDataSource.getPlaceById(id);
      return Right(place.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getCategories({bool forceRefresh = false}) async {
    try {
      // Check if we have cached categories and not forcing refresh
      if (!forceRefresh) {
        final hasCached = await localDataSource.hasCachedCategories();
        if (hasCached) {
          print('🏷️ Loading categories from cache');
          final cachedCategories = await localDataSource.getCategories();
          if (cachedCategories.isNotEmpty) {
            return Right(cachedCategories);
          }
        }
      }

      print('🏷️ Getting categories from remote data source');
      final categories = await remoteDataSource.getCategories();
      
      // Save to cache
      if (categories.isNotEmpty) {
        await localDataSource.saveCategories(categories);
      }
      
      return Right(categories);
    } catch (e) {
      print('❌ Error getting categories from remote, trying cache: $e');
      
      // Fallback to cache if available
      try {
        final cachedCategories = await localDataSource.getCategories();
        if (cachedCategories.isNotEmpty) {
          print('🏷️ Using cached categories as fallback');
          return Right(cachedCategories);
        }
      } catch (cacheError) {
        print('❌ Cache fallback also failed: $cacheError');
      }
      
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<PlaceEntity>>> getFavoritePlaces() async {
    try {
      final places = await localDataSource.getFavoritePlaces();
      return Right(places);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> toggleFavorite(int placeId, bool isFavorite) async {
    try {
      await localDataSource.toggleFavorite(placeId, isFavorite);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearPlaces();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
