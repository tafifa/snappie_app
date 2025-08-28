import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';
import '../base_usecase.dart';

class GetUsersUseCase implements UseCase<List<UserEntity>, PaginationParams> {
  final UserRepository repository;
  
  GetUsersUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<UserEntity>>> call(PaginationParams params) async {
    return await repository.getUsers(
      page: params.page,
      perPage: params.limit,
      search: params.search,
    );
  }
}
