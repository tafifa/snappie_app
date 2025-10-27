import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/articles_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../../shared/widgets/_display_widgets/network_image_widget.dart';

/// Reusable Article Card Widget
/// 
/// Displays article in a horizontal layout with:
/// - Left: Article image (60x60)
/// - Right: Content (title, excerpt, category, date, publisher)
/// - Opens external URL when tapped
class ArticleCardWidget extends StatelessWidget {
  final ArticlesModel article;
  final EdgeInsets? margin;

  const ArticleCardWidget({
    super.key,
    required this.article,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
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
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image (Left Side)
              _buildArticleImage(),
              
              const SizedBox(width: 12),
              
              // Article Content (Right Side)
              _buildArticleContent()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: NetworkImageWidget(
        imageUrl: article.imageUrl ?? '',
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorWidget: Container(
          width: 90,
          height: 90,
          color: AppColors.surfaceContainer,
          child: Icon(
            Icons.article_outlined,
            color: AppColors.textTertiary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        // Title (2 lines max)
        Text(
          article.title ?? 'No Title',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Excerpt/Description (2 lines)
        if (article.content != null)
          Text(
            article.content!,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        
        const SizedBox(height: 8),
        
        // Category
        Text(
          article.category ?? 'Uncategorized',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Author
            Text(
              'oleh ${article.user!.name}',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),

            // Date
            Text(
              _formatDate(),
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
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

  Future<void> _handleTap() async {
    final url = article.url;
    if (url != null && url.isNotEmpty) {
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        debugPrint('Error opening URL: $e');
      }
    }
  }
}
