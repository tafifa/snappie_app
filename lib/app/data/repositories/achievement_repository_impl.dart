import '../../core/network/network_info.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/achievement_remote_datasource.dart';
import '../models/achievement_model.dart';

abstract class AchievementRepository {
  Future<List<LeaderboardEntry>> getWeeklyLeaderboard();
  Future<List<LeaderboardEntry>> getMonthlyLeaderboard();
  Future<PaginatedUserRewards> getUserRewards(int userId, {int page, int perPage});
  Future<PaginatedUserAchievements> getUserAchievements(int userId, {int page, int perPage});
  Future<PaginatedUserChallenges> getUserChallenges(int userId, {int page, int perPage});
}

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AchievementRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<LeaderboardEntry>> getWeeklyLeaderboard() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    return await remoteDataSource.getWeeklyLeaderboard();
  }

  @override
  Future<List<LeaderboardEntry>> getMonthlyLeaderboard() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    return await remoteDataSource.getMonthlyLeaderboard();
  }

  @override
  Future<PaginatedUserRewards> getUserRewards(int userId, {int page = 1, int perPage = 10}) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    return await remoteDataSource.getUserRewards(userId, page: page, perPage: perPage);
  }

  @override
  Future<PaginatedUserAchievements> getUserAchievements(int userId, {int page = 1, int perPage = 10}) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    return await remoteDataSource.getUserAchievements(userId, page: page, perPage: perPage);
  }

  @override
  Future<PaginatedUserChallenges> getUserChallenges(int userId, {int page = 1, int perPage = 10}) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    return await remoteDataSource.getUserChallenges(userId, page: page, perPage: perPage);
  }
}
