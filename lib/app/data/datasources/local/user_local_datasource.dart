// user_local_data_source.dart
import 'package:isar/isar.dart';
import '../../../core/services/isar_service.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';
import '../../models/auth_token_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();

  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);
  Future<void> clearAuthToken();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  const UserLocalDataSourceImpl();

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
        await isar.userModels.clear(); // keep a single cached user
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
        // Thanks to @Index(unique: true, replace: true),
        // this put() will upsert by key without manual delete.
        await isar.authTokenModels.put(
          AuthTokenModel.create(
            key: 'auth_token',
            token: token,
          ),
        );
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
        // You can keep this filter-based delete; it’s simple & reliable.
        final tokens = await isar.authTokenModels
            .filter()
            .keyEqualTo('auth_token')
            .findAll();

        if (tokens.isNotEmpty) {
          await isar.authTokenModels.deleteAll(
            tokens.map((e) => e.isarId).toList(),
          );
        }
      });
    } catch (e) {
      throw CacheException('Failed to clear auth token: $e');
    }
  }
}
