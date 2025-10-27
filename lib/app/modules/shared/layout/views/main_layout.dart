import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../home/views/home_view.dart';
import '../../../explore/views/explore_view.dart';
import '../../../articles/views/articles_view.dart';
import '../../../profile/views/profile_view.dart';
import '../controllers/main_controller.dart';
import '../widgets/nav_item.dart';
import '../../widgets/lazy_indexed_child.dart';

class MainLayout extends GetView<MainController> {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex,
        children: [
          // Lazy load setiap tab - build hanya saat pertama kali dibuka
          LazyIndexedChild(
            builder: () => const HomeView(),
            isActive: controller.currentIndex == 0,
          ),
          LazyIndexedChild(
            builder: () => const ExploreView(),
            isActive: controller.currentIndex == 1,
          ),
          LazyIndexedChild(
            builder: () => const ArticlesView(),
            isActive: controller.currentIndex == 2,
          ),
          LazyIndexedChild(
            builder: () => const ProfileView(),
            isActive: controller.currentIndex == 3,
          ),
        ],
      )),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                isActive: controller.currentIndex == 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Beranda',
                onTap: () => controller.changeTab(0),
              ),
              NavItem(
                isActive: controller.currentIndex == 1,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Jelajahi',
                onTap: () => controller.changeTab(1),
              ),
              NavItem(
                isActive: controller.currentIndex == 2,
                icon: Icons.article_outlined,
                activeIcon: Icons.article,
                label: 'Artikel',
                onTap: () => controller.changeTab(2),
              ),
              NavItem(
                isActive: controller.currentIndex == 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Akun',
                onTap: () => controller.changeTab(3),
              ),
            ],
          )),
        ),
      ),
    );
  }

}
