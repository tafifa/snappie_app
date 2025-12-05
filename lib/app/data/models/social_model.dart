import 'package:json_annotation/json_annotation.dart';

part 'social_model.g.dart';

/// Social follow data containing followers and following lists
@JsonSerializable(explicitToJson: true)
class SocialFollowData {
  @JsonKey(name: 'followers')
  final List<FollowEntry>? followers;
  
  @JsonKey(name: 'total_followers')
  final int? totalFollowers;
  
  @JsonKey(name: 'following')
  final List<FollowEntry>? following;
  
  @JsonKey(name: 'total_following')
  final int? totalFollowing;

  SocialFollowData({
    this.followers,
    this.totalFollowers,
    this.following,
    this.totalFollowing,
  });

  factory SocialFollowData.fromJson(Map<String, dynamic> json) =>
      _$SocialFollowDataFromJson(json);

  Map<String, dynamic> toJson() => _$SocialFollowDataToJson(this);
}

/// Individual follow entry
@JsonSerializable(explicitToJson: true)
class FollowEntry {
  final int? id;
  
  @JsonKey(name: 'follower_id')
  final int? followerId;
  
  @JsonKey(name: 'following_id')
  final int? followingId;
  
  @JsonKey(name: 'created_at')
  final String? createdAt;
  
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  // Nested user data from API - for followers list
  @JsonKey(name: 'follower')
  final FollowUser? follower;
  
  // Nested user data from API - for following list
  @JsonKey(name: 'following')
  final FollowUser? following;

  FollowEntry({
    this.id,
    this.followerId,
    this.followingId,
    this.createdAt,
    this.updatedAt,
    this.follower,
    this.following,
  });

  factory FollowEntry.fromJson(Map<String, dynamic> json) =>
      _$FollowEntryFromJson(json);

  Map<String, dynamic> toJson() => _$FollowEntryToJson(this);
}

/// User info in follow entry
@JsonSerializable()
class FollowUser {
  final int? id;
  final String? name;
  final String? username;
  
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  
  @JsonKey(name: 'is_followed')
  final bool? isFollowed;

  FollowUser({
    this.id,
    this.name,
    this.username,
    this.imageUrl,
    this.isFollowed,
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) =>
      _$FollowUserFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUserToJson(this);
}
