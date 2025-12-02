import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@collection
@JsonSerializable()
class ReviewModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? id;

  @JsonKey(name: 'user_id')  int? userId;
  @JsonKey(name: 'place_id') int? placeId;

  String? content;

  @JsonKey(name: 'image_urls') 
  List<String>? imageUrls;

  @JsonKey(name: 'total_like') 
  int? totalLike;
  int? rating;
  bool? status;

  @JsonKey(name: 'additional_info')
  @ignore // Isar doesn't support Map, so ignore for local storage
  Map<String, dynamic>? additionalInfo;

  @JsonKey(name: 'user')
  UserReview? user;

  @JsonKey(name: 'created_at') DateTime? createdAt;
  @JsonKey(name: 'updated_at') DateTime? updatedAt;

  ReviewModel();
  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
@embedded
class UserReview {
  int? id;
  String? name;
  String? email;
  @JsonKey(name: 'image_url') String? imageUrl;

  UserReview();

  factory UserReview.fromJson(Map<String, dynamic> json) =>
      _$UserReviewFromJson(json);
  Map<String, dynamic> toJson() => _$UserReviewToJson(this);
}