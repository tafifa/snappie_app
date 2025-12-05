import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../data/repositories/post_repository_impl.dart';
import '../../../data/repositories/place_repository_impl.dart';
import '../../../data/repositories/achievement_repository_impl.dart';

/// Binding untuk Profile module
/// Lazy load saat tab Profile dibuka
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        authService: Get.find<AuthService>(),
        userRepository: Get.find<UserRepository>(),
        postRepository: Get.find<PostRepository>(),
        placeRepository: Get.find<PlaceRepository>(),
        achievementRepository: Get.find<AchievementRepository>(),
      ),
    );
  }
}
