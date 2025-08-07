import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/checkin_entity.dart';
import '../../repositories/checkin_repository.dart';
import '../base_usecase.dart';

class CreateCheckinUseCase implements UseCase<CheckinEntity, CreateCheckinParams> {
  final CheckinRepository repository;

  CreateCheckinUseCase(this.repository);

  @override
  Future<Either<Failure, CheckinEntity>> call(CreateCheckinParams params) async {
    return await repository.createCheckin(
      placeId: params.placeId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class CreateCheckinParams {
  final int placeId;
  final double latitude;
  final double longitude;

  CreateCheckinParams({
    required this.placeId,
    required this.latitude,
    required this.longitude,
  });
}