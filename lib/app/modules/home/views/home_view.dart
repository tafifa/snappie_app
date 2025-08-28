import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/constants/app_colors.dart';

import '../../../domain/entities/post_entity.dart';
import '../widgets/post_card.dart';
import '../widgets/post_creation_widget.dart';
import '../../../core/components/app_header_widget.dart';
import '../../../core/components/notification_button_widget.dart';
import '../../articles/widgets/common/loading_state_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainer,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshData();
        },
        child: CustomScrollView(
          slivers: [
            Obx(() => AppHeaderWidget(
              greeting: 'Hello, ${controller.userData['name'] ?? 'User'}!',
              subtitle: 'Selamat datang kembali',
              actionButton: NotificationButtonWidget(
                onPressed: () => _showNotifications(),
                hasNotification: true,
              ),
            )),

            // Post Creation Section
            Obx(() => SliverToBoxAdapter(
              child: PostCreationWidget(
                username: controller.userData['name'] ?? 'User',
                avatarUrl: controller.userData['avatar'],
                onTap: () => _showCreatePost(),
                onPhotoTap: () => _showPhotoOptions(),
              ),
            )),

            // Posts Timeline
            Obx(() {
              if (controller.isLoading && controller.posts.isEmpty) {
                return const LoadingStateWidget(
                  isSliver: true,
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = controller.posts[index];
                    return PostCard(
                      post: post,
                      onCommentTap: () => _showComments(post),
                      onShareTap: () => _sharePost(post),
                      onMoreTap: () => _showPostOptions(post),
                    );
                  },
                  childCount: controller.posts.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showComments(PostEntity post) {
    final TextEditingController commentController = TextEditingController();

    Get.bottomSheet(
      SafeArea(
        top: true,
        bottom: true,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            // Pastikan konten naik ketika keyboard muncul
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: Container(
            height: Get.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // header
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: const Center(
                    child: Text(
                      'Komentar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),

                // body
                const Expanded(
                  child: Center(
                    child: Text(
                      'Belum ada komentar',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top:
                        false, // cukup lindungi bottom agar tidak numpuk dengan gesture bar
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Tambahkan komentar...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                _addComment(post, value.trim());
                                commentController.clear();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            if (commentController.text.trim().isNotEmpty) {
                              _addComment(post, commentController.text.trim());
                              commentController.clear();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false, // penting supaya tidak nabrak notch/status bar
      enableDrag: true,
    );
  }

  void _addComment(PostEntity post, String comment) {
    // TODO: Implement add comment functionality
    Get.snackbar(
      'Komentar Ditambahkan',
      'Komentar "$comment" berhasil ditambahkan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _sharePost(PostEntity post) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Bagikan Post',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.copy, 'Salin Link'),
                _buildShareOption(Icons.share, 'Bagikan'),
                _buildShareOption(Icons.bookmark_border, 'Simpan'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.snackbar('Info', '$label berhasil');
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showPostOptions(PostEntity post) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('Simpan Post'),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Post disimpan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_remove),
              title: Text('Sembunyikan dari ${post.username}'),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Post disembunyikan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Laporkan Post',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Post dilaporkan');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications() {
    Get.bottomSheet(
      SafeArea(
        top: true,
        bottom: true,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      iconSize: 24,
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    SizedBox(height: 10),
                    // ... your items
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false, // <- penting agar tidak nabrak notch
      // gunakan barrierColor jika perlu: barrierColor: Colors.black54,
      enableDrag: true,
    );
  }


  void _showCreatePost() {
    // TODO: Implement create post functionality
    Get.snackbar(
      'Info',
      'Create post functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showPhotoOptions() {
    // TODO: Implement photo options functionality
    Get.snackbar(
      'Info',
      'Photo options functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
