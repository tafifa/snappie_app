import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/place_repository.dart';
import '../base_usecase.dart';

class GetCategoriesUseCase implements UseCase<List<String>, NoParams> {
  final PlaceRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}