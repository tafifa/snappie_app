import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
  
  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatar,
    createdAt,
    updatedAt,
    isActive,
  ];
  
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
