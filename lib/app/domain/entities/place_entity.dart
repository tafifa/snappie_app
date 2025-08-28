import 'package:equatable/equatable.dart';

class PlaceEntity extends Equatable {
  final int id;
  final String name;
  final String? category;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<String> imageUrls;
  final bool partnershipStatus;
  final RewardInfo? rewardInfo;
  final double? averageRating;
  final int? totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? distance; // For nearby places

  const PlaceEntity({
    required this.id,
    required this.name,
    this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.partnershipStatus,
    required this.rewardInfo,
    required this.averageRating,
    required this.totalReviews,
    required this.createdAt,
    required this.updatedAt,
    this.distance,
  });

  // Computed properties for backward compatibility
  String? get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;
  bool get isFavorite => false; // TODO: Implement favorite logic
  double get rating => averageRating ?? 0.0;
  int get reviewCount => totalReviews ?? 0;
  bool get isPartner => partnershipStatus;
  int get rewardXp => rewardInfo?.baseExp ?? 0;
  int get rewardCoins => rewardInfo?.baseCoin ?? 0;
  String get description => ''; // TODO: Add description field if needed
  
  @override
  List<Object?> get props => [
        id,
        name,
        category,
        address,
        latitude,
        longitude,
        imageUrls,
        partnershipStatus,
        rewardInfo,
        averageRating,
        totalReviews,
        createdAt,
        updatedAt,
        distance,
      ];
}

class RewardInfo extends Equatable {
  final int? baseExp;
  final int? baseCoin;

  const RewardInfo({
    this.baseExp,
    this.baseCoin,
  });

  @override
  List<Object?> get props => [baseExp, baseCoin];
}

enum PlaceCategory {
  cafe,
  traditional,
  foodCourt,
  streetFood,
  restaurant,
  shopping,
  entertainment,
  tourism,
  education,
  healthcare,
  transportation,
  other,
}

enum PartnershipStatus {
  active,
  inactive,
  pending,
}
