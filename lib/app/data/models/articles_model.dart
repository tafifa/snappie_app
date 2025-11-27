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

  String? author;
  String? title;
  String? category;
  String? description;
  @JsonKey(name: 'image_url') String? imageUrl;
  String? link; 

  @JsonKey(name: 'created_at') DateTime? createdAt;
  @JsonKey(name: 'updated_at') DateTime? updatedAt;

  ArticlesModel();

  factory ArticlesModel.fromJson(Map<String, dynamic> json) => _$ArticlesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesModelToJson(this);
}
