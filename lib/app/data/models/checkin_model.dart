import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkin_model.g.dart';

@collection
@JsonSerializable()
class CheckinModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? id;

  @Index() @JsonKey(name: 'user_id')  int? userId;
  @Index() @JsonKey(name: 'place_id') int? placeId;

  double? latitude;
  double? longitude;

  @JsonKey(name: 'image_url') String? imageUrl;
  bool? status;

  @JsonKey(name: 'created_at') DateTime? createdAt;
  @JsonKey(name: 'updated_at') DateTime? updatedAt;

  CheckinModel();
  factory CheckinModel.fromJson(Map<String, dynamic> json) =>
      _$CheckinModelFromJson(json);
  Map<String, dynamic> toJson() => _$CheckinModelToJson(this);
}
