import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

import '../../../core/utils/time_formatter.dart';
import '../../shared/widgets/_display_widgets/avatar_widget.dart';
import '../../shared/widgets/_display_widgets/rating_widget.dart';

class ReviewCardWidget extends StatelessWidget {
  final dynamic review; // Replace with actual Review entity
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onReplyTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showActions;
  final bool showImages;
  final int maxLines;

  const ReviewCardWidget({
    super.key,
    required this.review,
    this.onTap,
    this.onLikeTap,
    this.onReplyTap,
    this.margin,
    this.padding,
    this.showActions = true,
    this.showImages = true,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
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
            // User info and rating
            Row(
              children: [
                AvatarWidget(
                  imageUrl: review.userAvatar,
                  size: AvatarSize.small,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName ?? 'Anonymous',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          RatingWidget(
                            rating: review.rating?.toDouble() ?? 0.0,
                            size: 12,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            TimeFormatter.formatTimeAgo(review.createdAt ?? DateTime.now()),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Review content
            if (review.content != null && review.content!.isNotEmpty)
              Text(
                review.content!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            
            // Review images
            if (showImages && review.images != null && review.images!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review.images![index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: AppColors.surfaceContainer,
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textTertiary,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            
            // Actions
            if (showActions) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: onLikeTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          review.isLiked == true 
                              ? Icons.thumb_up 
                              : Icons.thumb_up_outlined,
                          size: 16,
                          color: review.isLiked == true 
                              ? AppColors.primary 
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${review.likesCount ?? 0}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onReplyTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.reply_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Balas',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
