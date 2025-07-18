import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';
import '../base_usecase.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final UserRepository repository;
  
  LoginUseCase(this.repository);
  
  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}