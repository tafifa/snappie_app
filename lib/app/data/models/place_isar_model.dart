import 'package:isar/isar.dart';
import '../../domain/entities/place_entity.dart';

part 'place_isar_model.g.dart';

@collection
class PlaceIsarModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late int placeId;
  
  late String name;
                String? category;
  late String address;
  
  double? latitude;
  double? longitude;
  
  @enumerated
  late List<String> imageUrls;
  
  late bool partnershipStatus;
  
  double? averageRating;
  int? totalReviews;
  
  late DateTime createdAt;
  late DateTime updatedAt;
  
  double? distance;
  
  // Reward info
  int? rewardBaseExp;
  int? rewardBaseCoin;
  
  // Cache metadata
  late DateTime lastSynced;
  late bool isFavorite;
  
  PlaceIsarModel();
  
  factory PlaceIsarModel.fromEntity(PlaceEntity entity) {
    final model = PlaceIsarModel()
      ..placeId = entity.id
      ..name = entity.name
      ..category = entity.category
      ..address = entity.address
      ..latitude = entity.latitude
      ..longitude = entity.longitude
      ..imageUrls = entity.imageUrls
      ..partnershipStatus = entity.partnershipStatus
      ..averageRating = entity.averageRating
      ..totalReviews = entity.totalReviews
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..distance = entity.distance
      ..rewardBaseExp = entity.rewardInfo?.baseExp
      ..rewardBaseCoin = entity.rewardInfo?.baseCoin
      ..lastSynced = DateTime.now()
      ..isFavorite = entity.isFavorite;
    
    return model;
  }
  
  PlaceEntity toEntity() {
    return PlaceEntity(
      id: placeId,
      name: name,
      category: category,
      address: address,
      latitude: latitude,
      longitude: longitude,
      imageUrls: imageUrls,
      partnershipStatus: partnershipStatus,
      rewardInfo: rewardBaseExp != null || rewardBaseCoin != null
          ? RewardInfo(baseExp: rewardBaseExp, baseCoin: rewardBaseCoin)
          : null,
      averageRating: averageRating,
      totalReviews: totalReviews,
      createdAt: createdAt,
      updatedAt: updatedAt,
      distance: distance,
    );
  }
}

@collection
class CacheMetadata {
  Id id = Isar.autoIncrement;
  
  late String key;
  late DateTime lastSynced;
  late String? etag;
  late int version;
  
  CacheMetadata();
}
