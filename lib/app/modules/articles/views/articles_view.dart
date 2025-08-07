import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/articles_controller.dart';
import '../widgets/articles_card.dart';
import '../widgets/articles_search_bar.dart';
import '../widgets/articles_category_filter.dart';
import 'articles_detail_view.dart';

class ArticlesView extends GetView<ArticlesController> {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFF2E8B8B),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Articles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2E8B8B),
                      Color(0xFF1F6B6B),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Implement search functionality
                },
                icon: const Icon(Icons.search, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement bookmark view
                },
                icon: const Icon(Icons.bookmark_outline, color: Colors.white),
              ),
            ],
          ),
      
          // Search Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ArticlesSearchBar(
                onSearchChanged: controller.searchArticles,
              ),
            ),
          ),
      
          // Category Filter
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => ArticlesCategoryFilter(
                categories: controller.categories,
                selectedCategory: controller.selectedCategory,
                onCategorySelected: controller.filterByCategory,
              )),
            ),
          ),
      
          // Articles List
          Obx(() {
            if (controller.isLoading && controller.articles.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2E8B8B),
                  ),
                ),
              );
            }
      
            if (controller.errorMessage.isNotEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.refreshArticles,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8B8B),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }
      
            if (controller.articles.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No articles found',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
      
            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < controller.articles.length) {
                      // Load more indicator
                      if (controller.hasMoreData) {
                        controller.loadMoreArticles();
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2E8B8B),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }
      
                    final article = controller.articles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ArticlesCard(
                        article: article,
                        onTap: () => _navigateToArticleDetail(article),
                        onBookmarkTap: () => controller.toggleBookmark(article),
                      ),
                    );
                  },
                  childCount: controller.articles.length + 
                      (controller.hasMoreData ? 1 : 0),
                ),
              ),
            );
          }),
        ],
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