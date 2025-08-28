import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class PaginationParams {
  final int page;
  final int limit;
  final String? search;
  
  const PaginationParams({
    this.page = 1,
    this.limit = 20,
    this.search,
  });
}

class IdParams {
  final String id;
  
  const IdParams(this.id);
}

class LoginParams {
  final String email;
  final String password;
  
  const LoginParams({
    required this.email,
    required this.password,
  });
}

class RegisterParams {
  final String email;
  final String password;
  final String name;
  
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

class EmailParams {
  final String email;
  
  const EmailParams(this.email);
}

class ResetPasswordParams {
  final String token;
  final String newPassword;
  
  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });
}
