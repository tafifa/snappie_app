import 'package:isar/isar.dart';

part 'auth_token_model.g.dart';

@collection
class AuthTokenModel {
  Id isarId = Isar.autoIncrement;

  /// Key unik untuk membedakan tipe token (misalnya: 'auth_token', 'refresh_token', dsb.)
  @Index(unique: true, replace: true)
  late String key;

  /// Token string aktual
  late String token;

  /// Waktu penyimpanan (opsional tapi berguna untuk debugging / refresh token policy)
  DateTime createdAt = DateTime.now();

  AuthTokenModel();

  /// Factory constructor untuk pembuatan instan
  AuthTokenModel.create({
    required this.key,
    required this.token,
  }) {
    createdAt = DateTime.now();
  }

  /// Optional helper: periksa apakah token masih valid berdasarkan waktu tertentu
  bool isRecent({Duration maxAge = const Duration(days: 30)}) {
    return DateTime.now().difference(createdAt) < maxAge;
  }

  @override
  String toString() => 'AuthTokenModel(key: $key, token: ${token.substring(0, token.length > 8 ? 8 : token.length)}..., createdAt: $createdAt)';
}
