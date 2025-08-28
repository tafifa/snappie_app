import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';

import '../controllers/articles_controller.dart';
import '../widgets/common/search_bar_widget.dart';
import '../widgets/common/section_header_widget.dart';
import '../widgets/common/loading_state_widget.dart';
import '../widgets/common/error_state_widget.dart';
import '../widgets/horizontal_article_card.dart';
import '../widgets/vertical_article_card.dart';
import 'articles_detail_view.dart';

class ArticlesView extends GetView<ArticlesController> {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainer,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 90,
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryLight,
                        AppColors.primaryDark,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: SearchBarWidget(
                              hintText: 'Cari artikel menarik...',
                              onChanged: controller.searchArticles,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Artikel Terbaru Section
            SliverToBoxAdapter(
              child: SectionHeaderWidget(
                title: 'Artikel Terbaru',
              actionText: 'Lihat Semua',
                onActionPressed: () {
                  // Navigate to all articles
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: Obx(() {
                        if (controller.isLoading && controller.articles.isEmpty) {
                          return const LoadingStateWidget();
                        }
                        
                        if (controller.articles.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum ada artikel',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        final latestArticles = controller.articles.take(5).toList();
                        
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: latestArticles.length,
                          itemBuilder: (context, index) {
                            final article = latestArticles[index];
                            return Container(
                              margin: EdgeInsets.only(
                                right: index < latestArticles.length - 1 ? 12 : 0,
                              ),
                              child: HorizontalArticleCard(
                                article: article,
                                width: 280,
                                height: 220,
                                onTap: () => _navigateToArticleDetail(article),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Artikel Terkini Section
            SliverToBoxAdapter(
              child: SectionHeaderWidget(
                title: 'Artikel Terkini',
              actionText: 'Lihat Semua',
                onActionPressed: () {
                  // Navigate to all articles
                },
              ),
            ),


            // Articles List
            Obx(() {
              if (controller.isLoading && controller.articles.isEmpty) {
                return const LoadingStateWidget(isSliver: true);
              }

              if (controller.articles.isEmpty) {
                return EmptyStateWidget(
                  message: 'Tidak ada artikel ditemukan',
                  icon: Icons.article_outlined,
                  isSliver: true,
                );
              }

              if (controller.articles.isEmpty) {
                return EmptyStateWidget(
                  message: 'Tidak ada artikel ditemukan',
                  icon: Icons.article_outlined,
                  isSliver: true,
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= controller.articles.length) {
                        return const SizedBox.shrink();
                      }

                      final article = controller.articles[index];
                      return VerticalArticleCard(
                        article: article,
                        onTap: () => _navigateToArticleDetail(article),
                      );
                    },
                    childCount: controller.articles.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _navigateToArticleDetail(article) {
    Get.to(
      () => const ArticlesDetailView(),
      arguments: article,
      transition: Transition.rightToLeft,
    );
  }
}
