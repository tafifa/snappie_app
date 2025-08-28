import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';
import '../../entities/place_entity.dart';
import '../../repositories/place_repository.dart';
import '../base_usecase.dart';

class GetNearbyPlacesUseCase implements UseCase<List<PlaceEntity>, GetNearbyPlacesParams> {
  final PlaceRepository repository;

  GetNearbyPlacesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlaceEntity>>> call(GetNearbyPlacesParams params) async {
    return await repository.getNearbyPlaces(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      category: params.category,
      limit: params.limit,
    );
  }
}

class GetNearbyPlacesParams {
  final double latitude;
  final double longitude;
  final double radius;
  final String? category;
  final int limit;

  GetNearbyPlacesParams({
    required this.latitude,
    required this.longitude,
    this.radius = 10.0,
    this.category,
    this.limit = 20,
  });
}
