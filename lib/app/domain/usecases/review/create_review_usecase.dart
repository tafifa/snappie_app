import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';
import '../../entities/review_entity.dart';
import '../../repositories/review_repository.dart';
import '../base_usecase.dart';

class CreateReviewUseCase implements UseCase<ReviewEntity, CreateReviewParams> {
  final ReviewRepository repository;

  CreateReviewUseCase(this.repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(CreateReviewParams params) async {
    return await repository.createReview(
      placeId: params.placeId,
      vote: params.vote,
      content: params.content,
      imageUrls: params.imageUrls,
    );
  }
}

class CreateReviewParams {
  final int placeId;
  final int vote;
  final String content;
  final List<String>? imageUrls;

  CreateReviewParams({
    required this.placeId,
    required this.vote,
    required this.content,
    this.imageUrls,
  });
}
