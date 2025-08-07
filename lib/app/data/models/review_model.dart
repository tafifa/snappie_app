import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/review_entity.dart';
import 'place_model.dart';
import 'user_model.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final int id;
  final PlaceModel place;
  final UserModel user;
  final int vote;
  final String content;
  @JsonKey(name: 'image_urls')
  final List<String> imageUrls;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.place,
    required this.user,
    required this.vote,
    required this.content,
    required this.imageUrls,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      place: place.toEntity(),
      user: user.toEntity(),
      vote: vote,
      content: content,
      imageUrls: imageUrls,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      place: PlaceModel.fromEntity(entity.place),
      user: UserModel.fromEntity(entity.user),
      vote: entity.vote,
      content: entity.content,
      imageUrls: entity.imageUrls,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}