import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/modules/shared/layout/views/scaffold_frame.dart';
import '../controllers/profile_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../shared/widgets/index.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger lazy initialization saat view pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeIfNeeded();
    });

    return ScaffoldFrame(
      controller: controller,
      headerHeight: 315,
      headerContent: _buildHeader(),
      slivers: [
        // Tab Bar (Clickable)
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.backgroundContainer,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTabItem('Postingan Saya', 0),
                  _buildTabItem('Tersimpan', 1),
                  _buildTabItem('Pencapaian', 2),
                ],
              ),
            ),
          ),
        ),

        // Tab Content
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(_buildTabContent()),
          ),
        ),
      ],
    );
    // ]);
  }

  Widget _buildHeader() {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: AppColors.border),
      // ),
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 75,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                        child: Text(
                      '900 XP',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 75,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                        child: Text(
                      '250 Koin',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    icon: Icons.person_add_outlined,
                    backgroundColor: AppColors.background,
                    onPressed: () => _showProfileSettings(),
                  ),
                  const SizedBox(width: 8),
                  ButtonWidget(
                    icon: Icons.share_outlined,
                    backgroundColor: AppColors.background,
                    onPressed: () => _showProfileSettings(),
                  ),
                  const SizedBox(width: 8),
                  ButtonWidget(
                    icon: Icons.settings_outlined,
                    backgroundColor: AppColors.background,
                    onPressed: () => _showProfileSettings(),
                  ),
                ],
              ),
            ],
          ),
      
          const SizedBox(height: 4),
      
          // Profile Avatar
          AvatarWidget(
            imageUrl: 'avatar_f1_hdpi.png',
            size: AvatarSize.extraLarge,
          ),
      
          const SizedBox(height: 8),
      
          // User Name
          Obx(() => Text(
                controller.userName,
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
      
          // User Email
          Obx(() => Text(
                controller.userNickname,
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
      
          const SizedBox(height: 8),
      
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Obx(() => _buildStatColumn(
                        '${controller.totalCheckins}',
                        'Check-ins',
                      )),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.borderLight,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: Obx(() => _buildStatColumn(
                        '${controller.totalReviews}',
                        'Reviews',
                      )),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.borderLight,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: Obx(() => _buildStatColumn(
                        '${controller.totalExp}',
                        'Points',
                      )),
                ),
              ],
            ),
          ),
      
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: AppColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return Obx(() {
      bool isSelected = controller.selectedTabIndex == index;
      return GestureDetector(
        onTap: () {
          controller.setSelectedTabIndex(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(24)),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textOnPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildTabContent() {
    switch (controller.selectedTabIndex) {
      case 0: // Postingan Saya
        return [
          Obx(() {
            if (controller.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada postingan',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai berbagi pengalaman Anda!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
        ];
      case 1: // Tersimpan
        return [
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada postingan tersimpan',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ];
      case 2: // Pencapaian
        return [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hidden Gems Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Temukan tempat tersembunyi yang menakjubkan',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildAchievementStat('50', 'Tempat', Icons.location_on),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAchievementStat('15', 'Kota', Icons.location_city),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAchievementStat('2', 'Pencapaian', Icons.star),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    _buildAchievementStat('3', 'Tantangan', Icons.emoji_events),
              ),
            ],
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildAchievementStat(String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileSettings() {
    Get.dialog(
      AlertDialog(
        title: Text('Pengaturan Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profil'),
              onTap: () {
                Get.back();
                _showEditProfile();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: AppColors.error,
              ),
              title: Text(
                'Keluar',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                Get.back();
                await controller.logout();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showEditProfile() {
    Get.dialog(
      AlertDialog(
        title: Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
