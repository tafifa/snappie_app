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
  Future<List<PostModel>> getPosts({
    int page = 1,
    bool trending = false,
    bool following = false,
  }) async {
    if (!(await networkInfo.isConnected)) {
      throw NetworkException('No internet connection');
    }

    final posts = await remoteDataSource.getPosts(
      page: page,
      trending: trending,
      following: following,
    );
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

  /// Get posts by place ID
  /// Throws: [NetworkException], [ServerException], [AuthenticationException], [AuthorizationException]
  Future<List<PostModel>> getPostsByPlaceId(int placeId, {int page = 1, int perPage = 20}) async {
    if (!(await networkInfo.isConnected)) {
      throw NetworkException('No internet connection');
    }

    return await remoteDataSource.getPostsByPlaceId(placeId, page: page, perPage: perPage);
  }
}
