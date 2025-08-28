import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../articles/controllers/articles_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../core/dependencies/dependency_injection.dart';
import '../../../core/services/auth_service.dart';
import '../../../domain/usecases/place/get_places_usecase.dart';
import '../../../domain/usecases/place/get_categories_usecase.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize core dependencies first
    DependencyInjection.init();
    
    // Use cases that might be needed globally
    Get.lazyPut<GetPlacesUseCase>(() => GetPlacesUseCase(Get.find()));
    Get.lazyPut<GetCategoriesUseCase>(() => GetCategoriesUseCase(Get.find()));
    
    // Main controller
    Get.lazyPut<MainController>(() => MainController());
    
    // All main layout controllers
    Get.lazyPut<HomeController>(
      () => HomeController(authService: Get.find<AuthService>()),
    );
    Get.lazyPut<ExploreController>(
      () => ExploreController(
        getPlacesUseCase: Get.find<GetPlacesUseCase>(),
        getCategoriesUseCase: Get.find<GetCategoriesUseCase>(),
        authService: Get.find<AuthService>(),
      ),
    );
    Get.lazyPut<ArticlesController>(
      () => ArticlesController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(authService: Get.find<AuthService>()),
    );
  }
}
