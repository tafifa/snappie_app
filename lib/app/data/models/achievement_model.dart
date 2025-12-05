import 'package:json_annotation/json_annotation.dart';

part 'achievement_model.g.dart';

/// Leaderboard entry model
@JsonSerializable()
class LeaderboardEntry {
  int? rank;
  @JsonKey(name: 'user_id')
  int? userId;
  String? name;
  String? username;
  @JsonKey(name: 'image_url')
  String? imageUrl;
  @JsonKey(name: 'total_exp')
  int? totalExp;
  @JsonKey(name: 'total_checkin')
  int? totalCheckin;
  String? period;

  LeaderboardEntry();

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);
}

/// User reward model
@JsonSerializable()
class UserReward {
  int? id;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'reward_id')
  int? rewardId;
  bool? status;
  @JsonKey(name: 'additional_info')
  RewardAdditionalInfo? additionalInfo;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;

  UserReward();

  factory UserReward.fromJson(Map<String, dynamic> json) =>
      _$UserRewardFromJson(json);
  Map<String, dynamic> toJson() => _$UserRewardToJson(this);
}

@JsonSerializable()
class RewardAdditionalInfo {
  @JsonKey(name: 'redemption_code')
  String? redemptionCode;
  @JsonKey(name: 'redeemed_at')
  String? redeemedAt;

  RewardAdditionalInfo();

  factory RewardAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      _$RewardAdditionalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RewardAdditionalInfoToJson(this);
}

/// User achievement model
@JsonSerializable()
class UserAchievement {
  int? id;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'achievement_id')
  int? achievementId;
  bool? status;
  @JsonKey(name: 'additional_info')
  AchievementAdditionalInfo? additionalInfo;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;

  UserAchievement();

  factory UserAchievement.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementFromJson(json);
  Map<String, dynamic> toJson() => _$UserAchievementToJson(this);
}

@JsonSerializable()
class AchievementAdditionalInfo {
  @JsonKey(name: 'unlocked_at')
  String? unlockedAt;
  String? progress;

  AchievementAdditionalInfo();

  factory AchievementAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      _$AchievementAdditionalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementAdditionalInfoToJson(this);
}

/// User challenge model
@JsonSerializable()
class UserChallenge {
  int? id;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'challenge_id')
  int? challengeId;
  bool? status;
  @JsonKey(name: 'additional_info')
  ChallengeAdditionalInfo? additionalInfo;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;

  UserChallenge();

  factory UserChallenge.fromJson(Map<String, dynamic> json) =>
      _$UserChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$UserChallengeToJson(this);
}

@JsonSerializable()
class ChallengeAdditionalInfo {
  @JsonKey(name: 'current_count')
  int? currentCount;
  @JsonKey(name: 'target_count')
  int? targetCount;
  @JsonKey(name: 'criteria_type')
  String? criteriaType;
  @JsonKey(name: 'completed_at')
  String? completedAt;

  ChallengeAdditionalInfo();

  factory ChallengeAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      _$ChallengeAdditionalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeAdditionalInfoToJson(this);
  
  /// Calculate progress percentage
  double get progressPercent {
    if (targetCount == null || targetCount == 0) return 0;
    return ((currentCount ?? 0) / targetCount!) * 100;
  }
}

/// Paginated response wrapper for achievements data
@JsonSerializable()
class PaginatedUserRewards {
  List<UserReward>? items;
  int? total;
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'per_page')
  int? perPage;
  @JsonKey(name: 'last_page')
  int? lastPage;

  PaginatedUserRewards();

  factory PaginatedUserRewards.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUserRewardsFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatedUserRewardsToJson(this);
}

@JsonSerializable()
class PaginatedUserAchievements {
  List<UserAchievement>? items;
  int? total;
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'per_page')
  int? perPage;
  @JsonKey(name: 'last_page')
  int? lastPage;

  PaginatedUserAchievements();

  factory PaginatedUserAchievements.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUserAchievementsFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatedUserAchievementsToJson(this);
}

@JsonSerializable()
class PaginatedUserChallenges {
  List<UserChallenge>? items;
  int? total;
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'per_page')
  int? perPage;
  @JsonKey(name: 'last_page')
  int? lastPage;

  PaginatedUserChallenges();

  factory PaginatedUserChallenges.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUserChallengesFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatedUserChallengesToJson(this);
}
