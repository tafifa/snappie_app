import '../../core/network/network_info.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/post_remote_datasource.dart';
import '../models/post_model.dart';

/// Post Repository - No domain layer, direct Model return
/// Throws exceptions instead of returning Either<Failure, T>
class PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PostRepository({
    required this.remoteDataSource,
    required this.networkInfo,
  });


  /// Get all posts
  /// Throws: [NetworkException], [ServerException]
  Future<List<PostModel>> getPosts() async {
    if (!(await networkInfo.isConnected)) {
      throw NetworkException('No internet connection');
    }

    final posts = await remoteDataSource.getPosts();
    return posts;
  }

  /// Get post by ID
  /// Throws: [NetworkException], [ServerException]
  Future<PostModel> getPostById(int id) async {
    if (!(await networkInfo.isConnected)) {
      throw NetworkException('No internet connection');
    }

    final post = await remoteDataSource.getPostById(id);
    return post;
  }
}
