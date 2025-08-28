import 'package:dartz/dartz.dart';
import '../../domain/errors/exceptions.dart';
import '../../domain/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/checkin_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_remote_datasource.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  final CheckinRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CheckinRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CheckinEntity>> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final checkin = await remoteDataSource.createCheckin(
          placeId: placeId,
          latitude: latitude,
          longitude: longitude,
        );
        return Right(checkin.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to create check-in: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CheckinEntity>>> getCheckinHistory({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final checkins = await remoteDataSource.getCheckinHistory(
          page: page,
          perPage: perPage,
          status: status,
        );
        return Right(checkins.map((checkin) => checkin.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get check-in history: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
