import 'package:dartz/dartz.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/articles_entity.dart';
import '../../domain/repositories/articles_repository.dart';
import '../../doma../../domain/errors/failures.dart';
import '../datasources/articles_remote_datasource.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ArticlesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ArticlesEntity>>> getArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final articles = await remoteDataSource.getArticles();
        return Right(articles.map((e) => e.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ArticlesEntity>> getArticleById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final article = await remoteDataSource.getArticleById(id);
        return Right(article.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ArticlesEntity>>> searchArticles(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final articles = await remoteDataSource.searchArticles(query);
        return Right(articles.map((e) => e.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> bookmarkArticle(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.bookmarkArticle(id);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ArticlesEntity>>> getBookmarkedArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final articles = await remoteDataSource.getBookmarkedArticles();
        return Right(articles.map((e) => e.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
