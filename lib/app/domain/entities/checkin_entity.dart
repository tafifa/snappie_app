import 'package:equatable/equatable.dart';
import 'place_entity.dart';
import 'user_entity.dart';

class CheckinEntity extends Equatable {
  final int id;
  final PlaceEntity place;
  final UserEntity user;
  final double latitude;
  final double longitude;
  final String checkinStatus;
  final String missionStatus;
  final CheckinRewards rewards;
  final UserStats userStats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CheckinEntity({
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
  
  // Computed property for backward compatibility
  String get status => checkinStatus;

  @override
  List<Object> get props => [
        id,
        place,
        user,
        latitude,
        longitude,
        checkinStatus,
        missionStatus,
        rewards,
        userStats,
        createdAt,
        updatedAt,
      ];
}

class CheckinRewards extends Equatable {
  final int baseExp;
  final int baseCoin;

  const CheckinRewards({
    required this.baseExp,
    required this.baseCoin,
  });

  @override
  List<Object> get props => [baseExp, baseCoin];
}

class UserStats extends Equatable {
  final int totalExp;
  final int totalCoin;
  final int level;

  const UserStats({
    required this.totalExp,
    required this.totalCoin,
    required this.level,
  });

  @override
  List<Object> get props => [totalExp, totalCoin, level];
}

enum CheckinStatus {
  approved,
  pending,
  rejected,
}

enum MissionStatus {
  completed,
  pending,
  failed,
}
