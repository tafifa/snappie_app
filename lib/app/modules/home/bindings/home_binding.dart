import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/repositories/post_repository_impl.dart';

/// Binding untuk Home module
/// Lazy load saat tab Home dibuka
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        authService: Get.find<AuthService>(),
        postRepository: Get.find<PostRepository>(),
      ),
    );
  }
}
