import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/constants/app_colors.dart';
import 'package:snappie_app/app/modules/shared/widgets/_form_widgets/rectangle_button_widget.dart';
import '../_display_widgets/avatar_widget.dart';
import '../_display_widgets/fullscreen_image_viewer.dart';
import '../_navigation_widgets/button_widget.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../data/models/post_model.dart';
import '../../../../modules/home/controllers/home_controller.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onPlaceTap;

  const PostCard({
    super.key,
    required this.post,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
    this.onMoreTap,
    this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(),
          _buildPostContent(),
          const SizedBox(height: 12),
          _buildPostImage(context),
          const SizedBox(height: 12),
          _buildPostActions(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    final username = post.user?.name ?? 'Unknown';
    final avatarUrl = post.user?.imageUrl;
    final placeName = post.place?.name ?? 'Unknown Place';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AvatarWidget(
            imageUrl: avatarUrl,
            size: AvatarSize.medium,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: onPlaceTap,
                  child: Text(
                    placeName,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildFollowButton(),
          ButtonWidget(
            icon: Icons.more_vert_outlined,
            iconColor: AppColors.textPrimary,
            onPressed: onMoreTap,
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            post.content ?? '',
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostImage(BuildContext context) {
    // Use first image from imageUrls array
    // final imageUrl = (post.imageUrls != null && post.imageUrls!.isNotEmpty) ? post.imageUrls!.first : null;
    final imageUrl = 'https://statik.tempo.co/data/2023/12/19/id_1264597/1264597_720.jpg';
    
    if (imageUrl == null) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showFullscreenImage(context),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 400, // Limit maximum height to prevent overflow
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover, // Changed from fill to cover for better aspect ratio
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            post.createdAt != null ? TimeFormatter.formatTimeAgo(post.createdAt!) : 'Unknown',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildLikeButton(),
          const SizedBox(width: 20),
          _buildCommentButton(),
          const SizedBox(width: 20),
          _buildShareButton(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    // Check if current user has liked this post by checking likes array
    final authService = Get.find<AuthService>();
    final currentUserId = authService.userData?.id;
    final isLiked = post.likes?.any((like) => like.userId == currentUserId) ?? false;
    
    return GestureDetector(
      onTap: onLikeTap ?? () => Get.find<HomeController>().likePost(post.id!),
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '${post.likesCount ?? 0}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentButton() {
    return GestureDetector(
      onTap: onCommentTap,
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '${post.commentsCount ?? 0}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: onShareTap,
      child: Icon(
        Icons.share_outlined,
        color: Colors.grey[600],
        size: 20,
      ),
    );
  }

  Widget _buildFollowButton() {
    return RectangleButtonWidget(
      text: 'Ikuti',
      backgroundColor: AppColors.accent,
      textColor: AppColors.textOnPrimary,
      size: RectangleButtonSize.small,
      borderRadius: BorderRadius.circular(24),
      onPressed: () => Get.find<HomeController>().followUser('${post.userId ?? 0}'),
    );
  }

  void _showFullscreenImage(BuildContext context) {
    FullscreenImageViewer.show(
      context: context,
      currentPost: post,
      onLikeTap: onLikeTap ?? () => Get.find<HomeController>().likePost(post.id!),
      onCommentTap: onCommentTap ?? () {},
      onShareTap: onShareTap ?? () {},
    );
  }
}
