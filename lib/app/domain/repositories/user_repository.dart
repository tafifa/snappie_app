import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, UserEntity>> getUserById(int id);
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page,
    int perPage,
    String? search,
  });
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, void>> deleteUser(int id);
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });
}
