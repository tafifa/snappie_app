import 'package:json_annotation/json_annotation.dart';
import 'package:isar/isar.dart';

part 'articles_model.g.dart';

@collection
@JsonSerializable()
class ArticlesModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? id;

  @Index() @JsonKey(name: 'user_id')  int? userId;
  @Index() @JsonKey(name: 'place_id') int? placeId;

  String? title;
  String? content;
  String? category;
  @JsonKey(name: 'image_url') String? imageUrl;
  String? url; // External URL to the article website
  @JsonKey(name: 'likes_count') int? likesCount;
  @JsonKey(name: 'comments_count') int? commentsCount;

  @JsonKey(name: 'user') 
  UserArticle? user;

  @JsonKey(name: 'created_at') DateTime? createdAt;
  @JsonKey(name: 'updated_at') DateTime? updatedAt;

  ArticlesModel();

  factory ArticlesModel.fromJson(Map<String, dynamic> json) => _$ArticlesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
@embedded
class UserArticle {
  int? id;
  String? name;
  String? email;
  @JsonKey(name: 'image_url') String? imageUrl;

  UserArticle();

  factory UserArticle.fromJson(Map<String, dynamic> json) => _$UserArticleFromJson(json);

  Map<String, dynamic> toJson() => _$UserArticleToJson(this);
}
