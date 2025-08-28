import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';
import '../../entities/place_entity.dart';
import '../../repositories/place_repository.dart';
import '../base_usecase.dart';

class GetPlaceByIdUseCase implements UseCase<PlaceEntity, GetPlaceByIdParams> {
  final PlaceRepository repository;

  GetPlaceByIdUseCase(this.repository);

  @override
  Future<Either<Failure, PlaceEntity>> call(GetPlaceByIdParams params) async {
    return await repository.getPlaceById(params.id);
  }
}

class GetPlaceByIdParams {
  final int id;

  GetPlaceByIdParams({required this.id});
}
