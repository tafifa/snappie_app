import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/articles_controller.dart';
import '../../shared/widgets/index.dart';
import '../../shared/layout/views/scaffold_frame.dart';

class ArticlesView extends GetView<ArticlesController> {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger lazy initialization saat view pertama kali di-build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeIfNeeded();
    });

    return ScaffoldFrame(
      controller: controller,
      headerHeight: 75,
      headerContent: SearchBarWidget(
        hintText: 'Cari artikel menarik...',
        enableGlassmorphism: true,
        margin: const EdgeInsets.only(top: 16),
        onChanged: (value) {
          controller.searchArticles(value);
        },
      ),
      slivers: [
        // Articles List
        Obx(() {
          if (controller.isLoading && controller.articles.isEmpty) {
            return const LoadingStateWidget(isSliver: true);
          }

          if (controller.articles.isEmpty) {
            return SliverFillRemaining(
              child: NoDataEmptyState(),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= controller.articles.length) {
                    return const SizedBox.shrink();
                  }

                  final article = controller.articles[index];
                  return ArticleCardWidget(
                    article: article,
                  );
                },
                childCount: controller.articles.length,
              ),
            ),
          );
        }),
      ],
    );
  }
}
