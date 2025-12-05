import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class CommentModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? id;

  @Index() @JsonKey(name: 'user_id')  int? userId;

  @JsonKey(name: 'related_to_type')   String? relatedToType;
  @JsonKey(name: 'related_to_id')     int? relatedToId;
  
  String? comment;

  @JsonKey(name: 'total_like')        int? totalLike;
  @JsonKey(name: 'total_reply')       int? totalReply;

  @JsonKey(name: 'created_at')        DateTime? createdAt;
  @JsonKey(name: 'updated_at')        DateTime? updatedAt;

  UserComment? user;

  CommentModel();

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}

@JsonSerializable()
@embedded
class UserComment {
  int? id;
  String? name;
  String? username;
  @JsonKey(name: 'image_url') String? imageUrl;

  UserComment();

  factory UserComment.fromJson(Map<String, dynamic> json) =>
      _$UserCommentFromJson(json);
  Map<String, dynamic> toJson() => _$UserCommentToJson(this);
}