import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/checkin_entity.dart';
import 'place_model.dart';
import 'user_model.dart';

part 'checkin_model.g.dart';

@JsonSerializable()
class CheckinModel {
  final int id;
  final PlaceModel place;
  final UserModel user;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'checkin_status')
  final String checkinStatus;
  @JsonKey(name: 'mission_status')
  final String missionStatus;
  final CheckinRewardsModel rewards;
  @JsonKey(name: 'user_stats')
  final UserStatsModel userStats;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  CheckinModel({
    required this.id,
    required this.place,
    required this.user,
    required this.latitude,
    required this.longitude,
    required this.checkinStatus,
    required this.missionStatus,
    required this.rewards,
    required this.userStats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) =>
      _$CheckinModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinModelToJson(this);

  CheckinEntity toEntity() {
    return CheckinEntity(
      id: id,
      place: place.toEntity(),
      user: user.toEntity(),
      latitude: latitude,
      longitude: longitude,
      checkinStatus: checkinStatus,
      missionStatus: missionStatus,
      rewards: rewards.toEntity(),
      userStats: userStats.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CheckinModel.fromEntity(CheckinEntity entity) {
    return CheckinModel(
      id: entity.id,
      place: PlaceModel.fromEntity(entity.place),
      user: UserModel.fromEntity(entity.user),
      latitude: entity.latitude,
      longitude: entity.longitude,
      checkinStatus: entity.checkinStatus,
      missionStatus: entity.missionStatus,
      rewards: CheckinRewardsModel.fromEntity(entity.rewards),
      userStats: UserStatsModel.fromEntity(entity.userStats),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

@JsonSerializable()
class CheckinRewardsModel {
  @JsonKey(name: 'base_exp')
  final int baseExp;
  @JsonKey(name: 'base_coin')
  final int baseCoin;

  CheckinRewardsModel({
    required this.baseExp,
    required this.baseCoin,
  });

  factory CheckinRewardsModel.fromJson(Map<String, dynamic> json) =>
      _$CheckinRewardsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinRewardsModelToJson(this);

  CheckinRewards toEntity() {
    return CheckinRewards(
      baseExp: baseExp,
      baseCoin: baseCoin,
    );
  }

  factory CheckinRewardsModel.fromEntity(CheckinRewards entity) {
    return CheckinRewardsModel(
      baseExp: entity.baseExp,
      baseCoin: entity.baseCoin,
    );
  }
}

@JsonSerializable()
class UserStatsModel {
  @JsonKey(name: 'total_exp')
  final int totalExp;
  @JsonKey(name: 'total_coin')
  final int totalCoin;
  final int level;

  UserStatsModel({
    required this.totalExp,
    required this.totalCoin,
    required this.level,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  UserStats toEntity() {
    return UserStats(
      totalExp: totalExp,
      totalCoin: totalCoin,
      level: level,
    );
  }

  factory UserStatsModel.fromEntity(UserStats entity) {
    return UserStatsModel(
      totalExp: entity.totalExp,
      totalCoin: entity.totalCoin,
      level: entity.level,
    );
  }
}
