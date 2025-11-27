// user_repository_impl.dart
import '../../core/network/network_info.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../datasources/local/user_local_datasource.dart';
import '../models/user_model.dart';

/// User Repository (tanpa domain layer) – langsung mengembalikan UserModel
/// Melempar exception pada kegagalan (bukan Either).
class UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// Ambil profil user:
  /// - Online: tarik dari remote, lalu cache.
  /// - Offline: pakai cache (jika ada), kalau tidak ada lempar CacheException.
  Future<UserModel> getUserProfile() async {
    if (await networkInfo.isConnected) {
      final user = await remoteDataSource.getUserProfile();
      await localDataSource.cacheUser(user);
      return user;
    } else {
      final cached = await localDataSource.getCachedUser();
      if (cached != null) return cached;
      throw CacheException('No cached user found. Please connect to internet.');
    }
  }

  /// Ambil user by ID:
  /// - Online: tarik dari remote (opsional: update cache jika itu adalah user yang sedang login).
  /// - Offline: jika ID sama dengan user yang tersimpan di cache, kembalikan cache; selain itu lempar NetworkException.
  Future<UserModel> getUserById(int id) async {
    if (await networkInfo.isConnected) {
      final user = await remoteDataSource.getUserById(id);
      // Jika yang diminta adalah user yang sama dengan yang ada di cache profile, update cache juga.
      final cached = await localDataSource.getCachedUser();
      if (cached?.id == user.id) {
        await localDataSource.cacheUser(user);
      }
      return user;
    } else {
      final cached = await localDataSource.getCachedUser();
      if (cached != null && cached.id == id) return cached;
      throw NetworkException('No internet connection');
    }
  }

  /// Update profil user (payload akan dibungkus ulang ke `additional_info`
  /// oleh remote datasource). Berhasil -> cache diperbarui.
  ///
  /// Throws: [NetworkException], [ValidationException], [AuthenticationException], [ServerException]
  Future<UserModel> updateUserProfile({
    String? username,
    String? email,
    String? name,
    String? gender,
    String? imageUrl,
    List<String>? foodTypes,
    List<String>? placeValues,
    String? phone,
    DateTime? dateOfBirth,
    String? bio,
    Map<String, dynamic>? privacySettings,
    Map<String, dynamic>? notificationPreferences,
    Map<String, dynamic>? userSettings, // { language, theme }
    Map<String, dynamic>? userNotification, // { push_notification }
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    final updated = await remoteDataSource.updateUserProfile(
      username: username,
      email: email,
      name: name,
      gender: gender,
      imageUrl: imageUrl,
      foodTypes: foodTypes,
      placeValues: placeValues,
      phone: phone,
      dateOfBirth: dateOfBirth,
      bio: bio,
      privacySettings: privacySettings,
      notificationPreferences: notificationPreferences,
      userSettings: userSettings,
      userNotification: userNotification,
    );

    await localDataSource.cacheUser(updated);
    return updated;
  }
}
