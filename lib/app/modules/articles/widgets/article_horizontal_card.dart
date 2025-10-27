import 'package:flutter/material.dart';
import '../../../data/models/articles_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../../shared/widgets/_display_widgets/network_image_widget.dart';

/// Horizontal Article Card for Featured Articles
/// 
/// Displays article with:
/// - Top: Large image
/// - Bottom: Category, title, author, date
class ArticleHorizontalCard extends StatelessWidget {
  final ArticlesModel article;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const ArticleHorizontalCard({
    super.key,
    required this.article,
    this.onTap,
    this.width = 280,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image (Top)
            _buildArticleImage(),
            
            // Article Content (Bottom)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E8B8B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.category ?? 'Uncategorized',
                        style: const TextStyle(
                          color: Color(0xFF2E8B8B),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Title (2 lines max)
                    Text(
                      article.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    // Author and Date
                    Row(
                      children: [
                        // Author Avatar
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: AppColors.surfaceContainer,
                          child: Text(
                            (article.user?.name ?? 'U')[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        
                        // Author Name
                        Expanded(
                          child: Text(
                            'by ${article.user?.name ?? 'Unknown'}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        
                        // Date
                        Flexible(
                          child: Text(
                            _formatDate(),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: NetworkImageWidget(
        imageUrl: article.imageUrl ?? '',
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorWidget: Container(
          height: 120,
          color: AppColors.surfaceContainer,
          child: Icon(
            Icons.article_outlined,
            color: AppColors.textTertiary,
            size: 48,
          ),
        ),
      ),
    );
  }

  String _formatDate() {
    if (article.createdAt == null) {
      return 'Unknown';
    }
    
    final now = DateTime.now();
    final difference = now.difference(article.createdAt!);
    
    // If less than 7 days, show "X hari yang lalu"
    if (difference.inDays < 7) {
      if (difference.inDays == 0) {
        return 'Hari ini';
      } else if (difference.inDays == 1) {
        return '1 hari yang lalu';
      } else {
        return '${difference.inDays} hari yang lalu';
      }
    }
    
    // Otherwise show full date
    return TimeFormatter.formatDate(article.createdAt!);
  }
}
