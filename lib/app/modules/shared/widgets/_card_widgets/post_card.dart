import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/constants/app_colors.dart';
import 'package:snappie_app/app/core/constants/font_size.dart';
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
  final VoidCallback? onSaveTap;

  const PostCard({
    super.key,
    required this.post,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
    this.onMoreTap,
    this.onPlaceTap,
    this.onSaveTap,
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
                Text(
                  placeName,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
    // final imageUrl = (post.imageUrls != null && post.imageUrls!.isNotEmpty) ? post.imageUrls!.first : 'https://statik.tempo.co/data/2023/12/19/id_1264597/1264597_720.jpg';
    //  final imageUrls = post.imageUrls ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GestureDetector(
        //   onTap: () {
        //     FullscreenImageViewer.show(
        //       context: context,
        //       imageUrls: post.imageUrls ?? [imageUrl],
        //       initialIndex: 0,
        //       postOverlay: post,
        //     );
        //   },
        //   child: Container(
        //     width: double.infinity,
        //     constraints: const BoxConstraints(
        //       maxHeight: 400, // Limit maximum height to prevent overflow
        //     ),
        //     decoration: BoxDecoration(
        //       color: Colors.grey[200],
        //     ),
        //     child: Image.network(
        //       imageUrl,
        //       fit: BoxFit.cover, // Changed from fill to cover for better aspect ratio
        //       loadingBuilder: (context, child, loadingProgress) {
        //         if (loadingProgress == null) return child;
        //         return Container(
        //           height: 300,
        //           color: Colors.grey[200],
        //           child: Center(
        //             child: CircularProgressIndicator(
        //               value: loadingProgress.expectedTotalBytes != null
        //                   ? loadingProgress.cumulativeBytesLoaded /
        //                       loadingProgress.expectedTotalBytes!
        //                   : null,
        //               strokeWidth: 2,
        //               color: Colors.grey[400],
        //             ),
        //           ),
        //         );
        //       },
        //       errorBuilder: (context, error, stackTrace) {
        //         return Container(
        //           height: 200,
        //           padding: const EdgeInsets.all(20),
        //           color: Colors.grey[200],
        //           child: const Center(
        //             child: Icon(
        //               Icons.image_not_supported_outlined,
        //               color: Colors.grey,
        //               size: 40,
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        _buildImageSection(context, post),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                post.createdAt != null ? TimeFormatter.formatTimeAgo(post.createdAt!) : 'Unknown',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: FontSize.getSize(FontSizeOption.small),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // const SizedBox(width: 8),
              Spacer(),
              RectangleButtonWidget(
                text: 'Lihat Tempat',
                size: RectangleButtonSize.small,
                backgroundColor: AppColors.accent,
                borderRadius: BorderRadius.circular(24),
                onPressed: onPlaceTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context, PostModel? post) {
    double imageHeight = 300;
    final imageUrls = post?.imageUrls ?? [];
    print("imageUrls: $imageUrls");
    
    // If no images, show placeholder
    if (imageUrls.isEmpty) {
      return Container(
        height: imageHeight,
        width: double.infinity,
        color: AppColors.background,
        child: Center(
          child: Icon(
            Icons.restaurant,
            color: AppColors.textTertiary,
            size: imageHeight * 0.3,
          ),
        ),
      );
    }

    // If only one image, show it without carousel
    if (imageUrls.length == 1) {
      return Container(
        height: imageHeight,
        width: double.infinity,
        child: ClipRRect(
          child: Image.network(
            imageUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.background,
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    color: AppColors.textTertiary,
                    size: imageHeight * 0.3,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // Multiple images - show carousel
    final PageController pageController = PageController();
    final RxInt currentImageIndex = 0.obs;
    
    return Container(
      height: imageHeight,
      child: PageView.builder(
        controller: pageController,
        itemCount: imageUrls.length,
        onPageChanged: (index) => currentImageIndex.value = index,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
               FullscreenImageViewer.show(
                 context: context,
                 imageUrls: imageUrls,
                 initialIndex: index,
               );
             },
            child: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: imageHeight,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.background,
                          child: Center(
                            child: Icon(
                              Icons.restaurant,
                              color: AppColors.textTertiary,
                              size: imageHeight * 0.3,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Image counter overlay
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}/${imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            );
          },
        ),
      );
  }


  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildLikeButton(),
              const SizedBox(width: 20),
              _buildCommentButton(),
              const SizedBox(width: 20),
              _buildShareButton(),
            ],
          ),
           _buildSaveButton(),
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
            color: isLiked ? AppColors.error : AppColors.accent,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '${post.likesCount ?? 0}',
            style: TextStyle(
              color: AppColors.accent,
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
            color: AppColors.accent,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '${post.commentsCount ?? 0}',
            style: TextStyle(
              color: AppColors.accent,
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
        color: AppColors.accent,
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

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: onSaveTap,
      child: Icon(
        Icons.bookmark_border,
        color: AppColors.accent,
        size: 20,
      ),
    );
  }
}
