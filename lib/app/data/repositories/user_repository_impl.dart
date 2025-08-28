import 'package:dartz/dartz.dart';
import '../../domain/errors/exceptions.dart';
import '../../domain/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../datasources/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getProfile();
        await localDataSource.cacheUser(user);
        return Right(user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get current user: $e'));
      }
    } else {
      try {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        } else {
          return const Left(CacheFailure('No cached user found'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> getUserById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getUserById(id);
        return Right(user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get user: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final users = await remoteDataSource.getUsers(
          page: page,
          perPage: perPage,
          search: search,
        );
        return Right(users.map((user) => user.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to get users: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUser = await remoteDataSource.updateProfile(
          name: user.name,
          avatar: user.avatar,
        );
        await localDataSource.cacheUser(updatedUser);
        return Right(updatedUser.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to update user: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUser(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to delete user: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(
          email: email,
          password: password,
        );
        await localDataSource.cacheUser(user);
        return Right(user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to login: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
      await localDataSource.clearCachedUser();
      await localDataSource.clearAuthToken();
      return const Right(null);
    } on ServerException catch (e) {
      // Still clear local data even if server logout fails
      await localDataSource.clearCachedUser();
      await localDataSource.clearAuthToken();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await localDataSource.clearCachedUser();
      await localDataSource.clearAuthToken();
      return Left(UnknownFailure('Failed to logout: $e'));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.register(
          email: email,
          password: password,
          name: name,
        );
        await localDataSource.cacheUser(user);
        return Right(user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to register: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to send forgot password email: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(
          token: token,
          newPassword: newPassword,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Failed to reset password: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
