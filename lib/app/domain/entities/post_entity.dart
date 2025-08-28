// Post entity for social media timeline
class PostEntity {
  final int id;
  final String username;
  final String? userAvatar;
  final String placeName;
  final String placeAddress;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final List<String> tags;
  final bool isLiked;
  final bool isFollowing;

  PostEntity({
    required this.id,
    required this.username,
    this.userAvatar,
    required this.placeName,
    required this.placeAddress,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.tags,
    this.isLiked = false,
    this.isFollowing = false,
  });

  // Copy with method for immutable updates
  PostEntity copyWith({
    int? id,
    String? username,
    String? userAvatar,
    String? placeName,
    String? placeAddress,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    int? likes,
    int? comments,
    List<String>? tags,
    bool? isLiked,
    bool? isFollowing,
  }) {
    return PostEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      placeName: placeName ?? this.placeName,
      placeAddress: placeAddress ?? this.placeAddress,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PostEntity(id: $id, username: $username, placeName: $placeName)';
  }
}
