import 'package:get/get.dart';
import '../controllers/explore_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/repositories/place_repository_impl.dart';
import '../../../data/repositories/review_repository_impl.dart';
import '../../../data/repositories/checkin_repository_impl.dart';

/// Binding untuk Explore module
/// Lazy load saat tab Explore dibuka
class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreController>(
      () => ExploreController(
        placeRepository: Get.find<PlaceRepository>(),
        reviewRepository: Get.find<ReviewRepository>(),
        checkinRepository: Get.find<CheckinRepository>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
