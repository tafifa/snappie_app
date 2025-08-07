// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => PlaceModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrls: (json['image_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      partnershipStatus: json['partnership_status'] as String,
      rewardInfo:
          RewardInfoModel.fromJson(json['reward_info'] as Map<String, dynamic>),
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: (json['total_reviews'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image_urls': instance.imageUrls,
      'partnership_status': instance.partnershipStatus,
      'reward_info': instance.rewardInfo,
      'average_rating': instance.averageRating,
      'total_reviews': instance.totalReviews,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'distance': instance.distance,
    };

RewardInfoModel _$RewardInfoModelFromJson(Map<String, dynamic> json) =>
    RewardInfoModel(
      baseExp: (json['base_exp'] as num).toInt(),
      baseCoin: (json['base_coin'] as num).toInt(),
    );

Map<String, dynamic> _$RewardInfoModelToJson(RewardInfoModel instance) =>
    <String, dynamic>{
      'base_exp': instance.baseExp,
      'base_coin': instance.baseCoin,
    };
