import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/modules/shared/widgets/_display_widgets/avatar_widget.dart';
import 'package:snappie_app/app/modules/home/controllers/home_controller.dart';
import 'package:snappie_app/app/modules/explore/controllers/explore_controller.dart';

class FullscreenImageViewer {
  static String _getImageUrl(dynamic controller, int imageIndex) {
    if (controller is HomeController) {
      final urls = controller.selectedImageUrls;
      if (urls != null && imageIndex < urls.length) {
        return urls[imageIndex];
      }
    } else if (controller is ExploreController) {
      final urls = controller.selectedImageUrls;
      if (urls != null && imageIndex < urls.length) {
        return urls[imageIndex];
      }
    }
    return '';
  }

  static void show({
    required BuildContext context,
    final controller,
    int imageIndex = 0,
  }) {
    // Hide system UI for true fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Get.dialog(
      WillPopScope(
         onWillPop: () async {
           return true; // Allow the pop, system UI will be restored in .then()
         },
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
          children: [
            // Background overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    _getImageUrl(controller, imageIndex),
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 64,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Close button
            Positioned(
              top: MediaQuery.of(context).padding.top,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // User info overlay, display only if controller has selectedPost (HomeController)
            if (controller is HomeController && controller.selectedPost != null)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      AvatarWidget(
                        imageUrl:
                            (controller as HomeController).selectedPost?.user?.imageUrl ?? '',
                        size: AvatarSize.small,
                      ),
                      const SizedBox(width: 12),
                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (controller as HomeController).selectedPost?.user?.name ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (controller as HomeController).selectedPost?.place?.name ?? '',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Action buttons
                      Row(
                        children: [
                          // Like button
                          Obx(() {
                            final homeController = controller as HomeController;
                            final postData = homeController.posts.firstWhere(
                                (p) => p.id == homeController.selectedPost?.id);
                            return GestureDetector(
                              onTap: () {}, // Remove onLikeTap as it doesn't exist
                              child: Row(
                                children: [
                                  Icon(
                                    // post.isLiked ? Icons.favorite : Icons.favorite_border,
                                    // color: post.isLiked ? Colors.red : Colors.white,
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${postData.likesCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(width: 20),
                          // Comment button
                          Obx(() {
                            final homeController = controller as HomeController;
                            final postData = homeController.posts.firstWhere(
                                (p) => p.id == homeController.selectedPost?.id);
                            return GestureDetector(
                              onTap: () {}, // Remove onCommentTap as it doesn't exist
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${postData.commentsCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(width: 20),
                          // Share button
                          GestureDetector(
                            onTap: () {}, // Remove onShareTap as it doesn't exist
                            child: const Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                              size: 20,
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
      ),
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    ).then((_) {
      // Ensure system UI is restored when dialog is dismissed by any means
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }
}
