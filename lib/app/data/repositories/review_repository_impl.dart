import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReviewRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ReviewEntity>> createReview({
    required int placeId,
    required int vote,
    required String content,
    List<String>? imageUrls,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final review = await remoteDataSource.createReview(
          placeId: placeId,
          vote: vote,
          content: content,
          imageUrls: imageUrls,
        );
        return Right(review.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.statusCode));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to create review: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews({
    int page = 1,
    int perPage = 20,
    int? placeId,
    int? userId,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final reviews = await remoteDataSource.getReviews(
          page: page,
          perPage: perPage,
          placeId: placeId,
          userId: userId,
          status: status,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
        return Right(reviews.map((review) => review.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.statusCode));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get reviews: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}