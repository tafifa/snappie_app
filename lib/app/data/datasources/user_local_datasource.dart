import 'package:isar/isar.dart';
import '../../core/database/isar_service.dart';
import '../../domain/errors/exceptions.dart';
import '../models/user_model.dart';
import '../models/auth_token_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();
  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);
  Future<void> clearAuthToken();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl();
  
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final isar = await IsarService.instance;
      return await isar.userModels.where().findFirst();
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final isar = await IsarService.instance;
      await isar.writeTxn(() async {
        // Clear existing user first
        await isar.userModels.clear();
        // Save new user
        await isar.userModels.put(user);
      });
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }
  
  @override
  Future<void> clearCachedUser() async {
    try {
      final isar = await IsarService.instance;
      await isar.writeTxn(() async {
        await isar.userModels.clear();
      });
    } catch (e) {
      throw CacheException('Failed to clear cached user: $e');
    }
  }
  
  @override
  Future<String?> getAuthToken() async {
    try {
      final isar = await IsarService.instance;
      final tokenModel = await isar.authTokenModels
          .filter()
          .keyEqualTo('auth_token')
          .findFirst();
      return tokenModel?.token;
    } catch (e) {
      throw CacheException('Failed to get auth token: $e');
    }
  }
  
  @override
  Future<void> saveAuthToken(String token) async {
    try {
      final isar = await IsarService.instance;
      await isar.writeTxn(() async {
        // Remove existing token
        await isar.authTokenModels
            .filter()
            .keyEqualTo('auth_token')
            .deleteAll();
        // Save new token
        final tokenModel = AuthTokenModel.create(
          key: 'auth_token',
          token: token,
        );
        await isar.authTokenModels.put(tokenModel);
      });
    } catch (e) {
      throw CacheException('Failed to save auth token: $e');
    }
  }
  
  @override
  Future<void> clearAuthToken() async {
    try {
      final isar = await IsarService.instance;
      await isar.writeTxn(() async {
        await isar.authTokenModels
            .filter()
            .keyEqualTo('auth_token')
            .deleteAll();
      });
    } catch (e) {
      throw CacheException('Failed to clear auth token: $e');
    }
  }
}
