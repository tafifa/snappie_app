import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_remote_datasource.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlaceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    int page = 1,
    int perPage = 20,
    String? category,
    String? search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final places = await remoteDataSource.getPlaces(
          page: page,
          perPage: perPage,
          category: category,
          search: search,
        );
        return Right(places.map((place) => place.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.statusCode));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get places: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
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
    if (await networkInfo.isConnected) {
      try {
        final places = await remoteDataSource.getNearbyPlaces(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          category: category,
          limit: limit,
        );
        return Right(places.map((place) => place.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.statusCode));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get nearby places: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PlaceEntity>> getPlaceById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final place = await remoteDataSource.getPlaceById(id);
        return Right(place.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.statusCode));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get place: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.statusCode));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get categories: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}