class ArticlesEntity {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String imageUrl;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final List<String> tags;
  final int views;
  final int likes;
  final bool isBookmarked;

  ArticlesEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.tags,
    this.views = 0,
    this.likes = 0,
    this.isBookmarked = false,
  });

  ArticlesEntity copyWith({
    int? id,
    String? title,
    String? content,
    String? excerpt,
    String? imageUrl,
    String? author,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    List<String>? tags,
    int? views,
    int? likes,
    bool? isBookmarked,
  }) {
    return ArticlesEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      excerpt: excerpt ?? this.excerpt,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}