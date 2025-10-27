import 'package:get/get.dart';
import '../controllers/articles_controller.dart';
import '../../../data/repositories/articles_repository_impl.dart';

/// Binding untuk Articles module
/// Lazy load saat tab Articles dibuka
class ArticlesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticlesController>(
      () => ArticlesController(
        articlesRepository: Get.find<ArticlesRepository>(),
      ),
    );
  }
}
