import '../../core/network/network_info.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/social_remote_datasource.dart';
import '../models/social_model.dart';

abstract class SocialRepository {
  Future<SocialFollowData> getFollowData();
  Future<void> followUser(int userId);
}

class SocialRepositoryImpl implements SocialRepository {
  final SocialRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SocialRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<SocialFollowData> getFollowData() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    return await remoteDataSource.getFollowData();
  }

  @override
  Future<void> followUser(int userId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    return await remoteDataSource.followUser(userId);
  }
}
