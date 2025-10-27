import '../../core/network/network_info.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/articles_remote_datasource.dart';
import '../models/articles_model.dart';

/// Articles Repository - No domain layer, direct Model return
/// Throws exceptions instead of returning Either<Failure, T>
class ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ArticlesRepository({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  
  /// Get all articles
  /// Throws: [NetworkException], [ServerException]
  Future<List<ArticlesModel>> getArticles() async {
    if (!(await networkInfo.isConnected)) {
      throw NetworkException('No internet connection');
    }
    
    final articles = await remoteDataSource.getArticles();
    return articles;
  }

  /// Get article by ID
  /// Throws: [NetworkException], [ServerException]
  Future<ArticlesModel> getArticleById(int id) async {
    if (!(await networkInfo.isConnected)) {
      throw NetworkException('No internet connection');
    }
    
    final article = await remoteDataSource.getArticleById(id);
    return article;
  }
}
