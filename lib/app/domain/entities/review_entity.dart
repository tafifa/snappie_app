import 'package:equatable/equatable.dart';
import 'place_entity.dart';
import 'user_entity.dart';

class ReviewEntity extends Equatable {
  final int id;
  final PlaceEntity place;
  final UserEntity user;
  final int vote;
  final String content;
  final List<String> imageUrls;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewEntity({
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

  @override
  List<Object> get props => [
        id,
        place,
        user,
        vote,
        content,
        imageUrls,
        status,
        createdAt,
        updatedAt,
      ];
}

enum ReviewStatus {
  approved,
  pending,
  rejected,
  flagged,
}