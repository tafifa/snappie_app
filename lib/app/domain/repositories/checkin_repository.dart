import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/checkin_entity.dart';

abstract class CheckinRepository {
  /// Create a new check-in
  Future<Either<Failure, CheckinEntity>> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
  });

  /// Get check-in history with pagination and optional filters
  Future<Either<Failure, List<CheckinEntity>>> getCheckinHistory({
    int page = 1,
    int perPage = 20,
    String? status,
  });
}