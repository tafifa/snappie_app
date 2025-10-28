import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/constants/font_size.dart';
import 'package:snappie_app/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../../../core/constants/app_colors.dart';
import 'package:snappie_app/app/modules/shared/widgets/_navigation_widgets/button_widget.dart';
import '../../../data/models/post_model.dart';
import '../../shared/widgets/index.dart';
import '../../shared/widgets/_card_widgets/promotional_banner.dart';
import '../../shared/layout/views/scaffold_frame.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger lazy initialization saat view pertama kali di-build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeIfNeeded();
    });

    return ScaffoldFrame(
      controller: controller,
      headerHeight: 45,
      headerContent: _buildHeader(),
      slivers: [
        // Promotional Banner
        Obx(() => controller.showBanner
            ? SliverToBoxAdapter(
                child: PromotionalBanner(
                  title: 'Ayo Beraksi!',
                  subtitle: 'Raih XP, Koin, dan hadiah eksklusif lainnya dengan menyelesaikan misi!',
                  imageAsset: Image.asset('assets/logo/dark-hdpi.png'),
                  size: BannerSize.compact,
                  showCloseButton: true,
                  onClose: () => controller.hideBanner(),
                ),
              )
            : const SliverToBoxAdapter(child: SizedBox.shrink())),
        
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
                  onPlaceTap: () => Get.toNamed(AppPages.PLACE_DETAIL, arguments: post.place?.id),
                );
              },
              childCount: controller.posts.length,
            ),
          );
        }),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        shape: CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: AppColors.border),
      // ),
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Hello, ${controller.userData?.name ?? 'User'}!',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: FontSize.getSize(FontSizeOption.xl),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ButtonWidget(
            icon: Icons.person_add_outlined,
            backgroundColor: AppColors.background,
            onPressed: () => _showNotifications(),
          ),
          const SizedBox(width: 8),
          ButtonWidget(
            icon: Icons.notifications_outlined,
            backgroundColor: AppColors.background,
            onPressed: () => _showNotifications(),
            hasNotification: true, // TODO: ganti dengan logika sebenarnya
          ),
        ],
      ),
    );
  }

  void _showComments(PostModel post) {
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
                                borderSide: BorderSide(
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
                            decoration: BoxDecoration(
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

  void _addComment(PostModel post, String comment) {
    // TODO: Implement add comment functionality
    Get.snackbar(
      'Komentar Ditambahkan',
      'Komentar "$comment" berhasil ditambahkan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _sharePost(PostModel post) {
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

  void _showPostOptions(PostModel post) {
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
              title: Text('Sembunyikan dari ${post.user?.name}'),
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

  void _showCreatePostDialog() {
    Get.bottomSheet(
      SafeArea(
        top: true,
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Buat Postingan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text('Foto/Video', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Get.back();
                  // TODO: Navigate to create post with photo
                  Get.snackbar('Info', 'Fitur upload foto sedang dalam pengembangan');
                },
              ),
              ListTile(
                leading: Icon(Icons.article, color: AppColors.primary),
                title: Text('Status Text', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Get.back();
                  // TODO: Navigate to create text post
                  Get.snackbar('Info', 'Fitur post text sedang dalam pengembangan');
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: AppColors.primary),
                title: Text('Check-in Lokasi', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Get.back();
                  // TODO: Navigate to check-in
                  Get.snackbar('Info', 'Fitur check-in sedang dalam pengembangan');
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
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
}
