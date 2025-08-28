import 'package:isar/isar.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id isarId = Isar.autoIncrement; // Isar auto-increment ID
  
  @Index(unique: true)
  late String id;
  
  @Index()
  late String email;
  
  late String name;
  
  String? avatar;
  
  late DateTime createdAt;
  
  late DateTime updatedAt;
  
  late bool isActive;
  
  UserModel();
  
  UserModel.fromEntity(UserEntity entity) {
    id = entity.id;
    email = entity.email;
    name = entity.name;
    avatar = entity.avatar;
    createdAt = entity.createdAt;
    updatedAt = entity.updatedAt;
    isActive = entity.isActive;
  }
  
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final model = UserModel();
    model.id = json['id'] as String;
    model.email = json['email'] as String;
    model.name = json['name'] as String;
    model.avatar = json['avatar'] as String?;
    model.createdAt = DateTime.parse(json['created_at'] as String);
    model.updatedAt = DateTime.parse(json['updated_at'] as String);
    model.isActive = json['is_active'] as bool? ?? true;
    return model;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
    };
  }
  
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    final model = UserModel();
    model.id = id ?? this.id;
    model.email = email ?? this.email;
    model.name = name ?? this.name;
    model.avatar = avatar ?? this.avatar;
    model.createdAt = createdAt ?? this.createdAt;
    model.updatedAt = updatedAt ?? this.updatedAt;
    model.isActive = isActive ?? this.isActive;
    return model;
  }
}
