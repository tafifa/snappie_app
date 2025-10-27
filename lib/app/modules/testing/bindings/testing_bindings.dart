import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/register_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/google_auth_service.dart';

/// Binding untuk Testing Auth module
class TestingAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestingAuthController>(
      () => TestingAuthController(
        authService: Get.find<AuthService>(),
        googleAuthService: Get.find<GoogleAuthService>(),
      ),
    );
  }
}

/// Binding untuk Testing Register module
class TestingRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestingRegisterController>(
      () => TestingRegisterController(
        authService: Get.find<AuthService>(),
        googleAuthService: Get.find<GoogleAuthService>(),
      ),
    );
  }
}
