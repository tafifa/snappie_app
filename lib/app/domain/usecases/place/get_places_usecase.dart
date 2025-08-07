import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/place_entity.dart';
import '../../repositories/place_repository.dart';
import '../base_usecase.dart';

class GetPlacesUseCase implements UseCase<List<PlaceEntity>, GetPlacesParams> {
  final PlaceRepository repository;

  GetPlacesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlaceEntity>>> call(GetPlacesParams params) async {
    return await repository.getPlaces(
      page: params.page,
      perPage: params.perPage,
      category: params.category,
      search: params.search,
    );
  }
}

class GetPlacesParams {
  final int page;
  final int perPage;
  final String? category;
  final String? search;

  GetPlacesParams({
    this.page = 1,
    this.perPage = 20,
    this.category,
    this.search,
  });
}