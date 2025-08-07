// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckinModel _$CheckinModelFromJson(Map<String, dynamic> json) => CheckinModel(
      id: (json['id'] as num).toInt(),
      place: PlaceModel.fromJson(json['place'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      checkinStatus: json['checkin_status'] as String,
      missionStatus: json['mission_status'] as String,
      rewards:
          CheckinRewardsModel.fromJson(json['rewards'] as Map<String, dynamic>),
      userStats:
          UserStatsModel.fromJson(json['user_stats'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CheckinModelToJson(CheckinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'place': instance.place,
      'user': instance.user,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'checkin_status': instance.checkinStatus,
      'mission_status': instance.missionStatus,
      'rewards': instance.rewards,
      'user_stats': instance.userStats,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

CheckinRewardsModel _$CheckinRewardsModelFromJson(Map<String, dynamic> json) =>
    CheckinRewardsModel(
      baseExp: (json['base_exp'] as num).toInt(),
      baseCoin: (json['base_coin'] as num).toInt(),
    );

Map<String, dynamic> _$CheckinRewardsModelToJson(
        CheckinRewardsModel instance) =>
    <String, dynamic>{
      'base_exp': instance.baseExp,
      'base_coin': instance.baseCoin,
    };

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      totalExp: (json['total_exp'] as num).toInt(),
      totalCoin: (json['total_coin'] as num).toInt(),
      level: (json['level'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'total_exp': instance.totalExp,
      'total_coin': instance.totalCoin,
      'level': instance.level,
    };
