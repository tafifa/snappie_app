import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../../explore/views/explore_view.dart';
import '../../articles/views/articles_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_controller.dart';
import '../widgets/nav_item.dart';

class MainLayout extends GetView<MainController> {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const ExploreView(),
      const ArticlesView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex,
        children: pages,
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
                label: 'Home',
                onTap: () => controller.changeTab(0),
              ),
              NavItem(
                isActive: controller.currentIndex == 1,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explore',
                onTap: () => controller.changeTab(1),
              ),
              NavItem(
                isActive: controller.currentIndex == 2,
                icon: Icons.article_outlined,
                activeIcon: Icons.article,
                label: 'Articles',
                onTap: () => controller.changeTab(2),
              ),
              NavItem(
                isActive: controller.currentIndex == 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                onTap: () => controller.changeTab(3),
              ),
            ],
          )),
        ),
      ),
    );
  }

}
