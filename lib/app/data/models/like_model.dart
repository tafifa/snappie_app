import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'like_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class LikeModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? id;

  @Index() @JsonKey(name: 'user_id')  int? userId;
  @JsonKey(name: 'related_to_type')   String? relatedToType;
  @JsonKey(name: 'related_to_id')     int? relatedToId;
  @JsonKey(name: 'created_at')        String? createdAt;
  @JsonKey(name: 'updated_at')        String? updatedAt;
  UserLike? user;

  LikeModel();

  factory LikeModel.fromJson(Map<String, dynamic> json) =>
      _$LikeModelFromJson(json);
  Map<String, dynamic> toJson() => _$LikeModelToJson(this);
}

@JsonSerializable()
@embedded
class UserLike {
  int? id;
  String? name;
  @JsonKey(name: 'image_url') String? imageUrl;

  UserLike();

  factory UserLike.fromJson(Map<String, dynamic> json) =>
      _$UserLikeFromJson(json);
  Map<String, dynamic> toJson() => _$UserLikeToJson(this);
}