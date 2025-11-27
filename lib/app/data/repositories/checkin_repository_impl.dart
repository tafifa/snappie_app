import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/remote/checkin_remote_datasource.dart';
import '../models/checkin_model.dart';

/// Checkin Repository - No domain layer, direct Model return
/// Throws exceptions instead of returning Either<Failure, T>
class CheckinRepository {
  final CheckinRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CheckinRepository({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Create a new check-in
  /// Throws: [NetworkException], [ServerException], [ValidationException], [AuthenticationException], [AuthorizationException]
  Future<CheckinModel> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
    required Map<String, dynamic> additionalInfo,
  }) async {
    if (!(await networkInfo.isConnected)) {
      throw NetworkException('No internet connection');
    }

    final checkin = await remoteDataSource.createCheckin(
      placeId: placeId,
      latitude: latitude,
      longitude: longitude,
      additionalInfo: additionalInfo,
    );

    return checkin;
  }
}
