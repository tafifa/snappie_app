import '../../domain/entities/articles_entity.dart';

class ArticlesModel extends ArticlesEntity {
  ArticlesModel({
    required super.id,
    required super.title,
    required super.content,
    required super.excerpt,
    required super.imageUrl,
    required super.author,
    required super.createdAt,
    required super.updatedAt,
    required super.category,
    required super.tags,
    super.views = 0,
    super.likes = 0,
    super.isBookmarked = false,
  });

  factory ArticlesModel.fromJson(Map<String, dynamic> json) {
    return ArticlesModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      excerpt: json['excerpt'] as String,
      imageUrl: json['image_url'] as String,
      author: json['author'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category: json['category'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      views: json['views'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'image_url': imageUrl,
      'author': author,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category': category,
      'tags': tags,
      'views': views,
      'likes': likes,
      'is_bookmarked': isBookmarked,
    };
  }

  ArticlesEntity toEntity() => this;
}
