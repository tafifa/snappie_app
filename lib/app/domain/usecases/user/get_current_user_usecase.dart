import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';
import '../base_usecase.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  final UserRepository repository;
  
  GetCurrentUserUseCase(this.repository);
  
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}