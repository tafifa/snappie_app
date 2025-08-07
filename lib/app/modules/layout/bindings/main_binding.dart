import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../articles/controllers/articles_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize main controller
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    
    // Initialize all main controllers used in main layout
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    
    Get.lazyPut<ExploreController>(
      () => ExploreController(),
    );
    
    Get.lazyPut<ArticlesController>(
      () => ArticlesController(),
    );
    
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
