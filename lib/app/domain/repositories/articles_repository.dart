import 'package:dartz/dartz.dart';
import '../entities/articles_entity.dart';
import '../errors/failures.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<ArticlesEntity>>> getArticles();
  Future<Either<Failure, ArticlesEntity>> getArticleById(int id);
  Future<Either<Failure, List<ArticlesEntity>>> searchArticles(String query);
  Future<Either<Failure, bool>> bookmarkArticle(int id);
  Future<Either<Failure, List<ArticlesEntity>>> getBookmarkedArticles();
}
