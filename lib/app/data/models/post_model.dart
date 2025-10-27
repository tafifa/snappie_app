import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:snappie_app/app/data/models/comment_model.dart';
import 'package:snappie_app/app/data/models/like_model.dart';

part 'post_model.g.dart';

@collection
@JsonSerializable()
class PostModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? id;

  @Index() @JsonKey(name: 'user_id')  int? userId;
  @Index() @JsonKey(name: 'place_id') int? placeId;

  @JsonKey(name: 'image_urls')        List<String>? imageUrls;
  String? content;
  bool? status;

  @JsonKey(name: 'likes_count')       int? likesCount;
  @JsonKey(name: 'comments_count')    int? commentsCount;

  @JsonKey(name: 'created_at')        DateTime? createdAt;
  @JsonKey(name: 'updated_at')        DateTime? updatedAt;

  @JsonKey(name: 'user')              UserPost? user;
  @JsonKey(name: 'place')             PlacePost? place;
  @ignore
  @JsonKey(name: 'likes')             List<LikeModel>? likes;
  @ignore
  @JsonKey(name: 'comments')          List<CommentModel>? comments;

  PostModel();

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

@JsonSerializable()
@embedded
class UserPost {
  int? id;
  String? name;
  @JsonKey(name: 'image_url') String? imageUrl;

  UserPost();

  factory UserPost.fromJson(Map<String, dynamic> json) =>
      _$UserPostFromJson(json);
  Map<String, dynamic> toJson() => _$UserPostToJson(this);
}

@JsonSerializable()
@embedded
class PlacePost {
  int? id;
  String? name;
  String? description;

  PlacePost();

  factory PlacePost.fromJson(Map<String, dynamic> json) =>
      _$PlacePostFromJson(json);
  Map<String, dynamic> toJson() => _$PlacePostToJson(this);
}