import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/review_entity.dart';
import '../../repositories/review_repository.dart';
import '../base_usecase.dart';

class GetReviewsUseCase implements UseCase<List<ReviewEntity>, GetReviewsParams> {
  final ReviewRepository repository;

  GetReviewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(GetReviewsParams params) async {
    return await repository.getReviews(
      page: params.page,
      perPage: params.perPage,
      placeId: params.placeId,
      userId: params.userId,
      status: params.status,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

class GetReviewsParams {
  final int page;
  final int perPage;
  final int? placeId;
  final int? userId;
  final String? status;
  final String? sortBy;
  final String? sortOrder;

  GetReviewsParams({
    this.page = 1,
    this.perPage = 20,
    this.placeId,
    this.userId,
    this.status,
    this.sortBy,
    this.sortOrder,
  });
}