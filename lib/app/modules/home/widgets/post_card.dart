import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/components/user_avatar.dart';
import '../../../core/components/fullscreen_image_viewer.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../domain/entities/post_entity.dart';
import '../controllers/home_controller.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          UserAvatar(
            username: post.username,
            avatarUrl: post.userAvatar,
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: onPlaceTap,
                  child: Text(
                    post.placeName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildFollowButton(),
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
            post.content,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showFullscreenImage(context),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: post.imageUrl != null ? Image.network(
              post.imageUrl!,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
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
            ) : Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            TimeFormatter.formatTimeAgo(post.createdAt),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
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
    return Obx(() {
      final controller = Get.find<HomeController>();
      final currentPost = controller.posts.firstWhere((p) => p.id == post.id);
      return GestureDetector(
        onTap: onLikeTap ?? () => controller.likePost(post.id),
        child: Row(
          children: [
            Icon(
              currentPost.isLiked ? Icons.favorite : Icons.favorite_border,
              color: currentPost.isLiked ? Colors.red : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '${currentPost.likes}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    });
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
            '${post.comments}',
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
    return Obx(() {
      final controller = Get.find<HomeController>();
      final currentPost = controller.posts.firstWhere((p) => p.id == post.id);
      
      return CustomButton(
        text: currentPost.isFollowing ? 'Mengikuti' : 'Ikuti',
        icon: currentPost.isFollowing ? Icons.person : Icons.person_add_outlined,
        backgroundColor: currentPost.isFollowing ? Colors.grey[200] : Colors.orange[100],
        textColor: currentPost.isFollowing ? Colors.grey[700] : Colors.orange,
        borderColor: currentPost.isFollowing ? Colors.grey[400] : null,
        onTap: () => controller.followUser(post.username),
      );
    });
  }

  void _showFullscreenImage(BuildContext context) {
    FullscreenImageViewer.show(
      context: context,
      currentPost: post,
      onLikeTap: onLikeTap ?? () => Get.find<HomeController>().likePost(post.id),
      onCommentTap: onCommentTap ?? () {},
      onShareTap: onShareTap ?? () {},
    );
  }
}
