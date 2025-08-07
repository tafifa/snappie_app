import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/review_entity.dart';

abstract class ReviewRepository {
  /// Create a new review
  Future<Either<Failure, ReviewEntity>> createReview({
    required int placeId,
    required int vote,
    required String content,
    List<String>? imageUrls,
  });

  /// Get reviews with pagination and optional filters
  Future<Either<Failure, List<ReviewEntity>>> getReviews({
    int page = 1,
    int perPage = 20,
    int? placeId,
    int? userId,
    String? status,
    String? sortBy,
    String? sortOrder,
  });
}