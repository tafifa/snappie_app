import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/place_entity.dart';

part 'place_model.g.dart';

@JsonSerializable()
class PlaceModel {
  final int id;
  final String name;
  final String? category;
  final String address;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'image_urls')
  final List<String> imageUrls;
  @JsonKey(name: 'partnership_status')
  final bool partnershipStatus;
  @JsonKey(name: 'reward_info')
  final RewardInfoModel? rewardInfo;
  @JsonKey(name: 'stats')
  final StatsModel? stats;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final double? distance; // For nearby places

  PlaceModel({
    required this.id,
    required this.name,
    this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.partnershipStatus,
    required this.rewardInfo,
    this.stats,
    this.createdAt,
    this.updatedAt,
    this.distance,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);

  PlaceEntity toEntity() {
    return PlaceEntity(
      id: id,
      name: name,
      category: category,
      address: address,
      latitude: latitude,
      longitude: longitude,
      imageUrls: imageUrls,
      partnershipStatus: partnershipStatus,
      rewardInfo: rewardInfo?.toEntity(),
      averageRating: stats?.averageRating,
      totalReviews: stats?.totalReviews,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      distance: distance,
    );
  }

  factory PlaceModel.fromEntity(PlaceEntity entity) {
    return PlaceModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      imageUrls: entity.imageUrls,
      partnershipStatus: entity.partnershipStatus,
      rewardInfo: entity.rewardInfo != null ? RewardInfoModel.fromEntity(entity.rewardInfo!) : null,
      stats: StatsModel(
        averageRating: entity.averageRating,
        totalReviews: entity.totalReviews,
      ),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      distance: entity.distance,
    );
  }
}

@JsonSerializable()
class RewardInfoModel {
  @JsonKey(name: 'exp_reward')
  final int? baseExp;
  @JsonKey(name: 'coin_reward')
  final int? baseCoin;

  RewardInfoModel({
    this.baseExp,
    this.baseCoin,
  });

  factory RewardInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RewardInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$RewardInfoModelToJson(this);

  RewardInfo toEntity() {
    return RewardInfo(
      baseExp: baseExp,
      baseCoin: baseCoin,
    );
  }

  factory RewardInfoModel.fromEntity(RewardInfo entity) {
    return RewardInfoModel(
      baseExp: entity.baseExp,
      baseCoin: entity.baseCoin,
    );
  }
}

@JsonSerializable()
class StatsModel {
  @JsonKey(name: 'total_checkins')
  final int? totalCheckins;
  @JsonKey(name: 'total_reviews')
  final int? totalReviews;
  @JsonKey(name: 'average_rating')
  final double? averageRating;

  StatsModel({
    this.totalCheckins,
    this.totalReviews,
    this.averageRating,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) =>
      _$StatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatsModelToJson(this);
}
