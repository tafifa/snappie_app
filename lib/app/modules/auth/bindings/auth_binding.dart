import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthController>(
      () => AuthController(authService: Get.find<AuthService>()),
    );
  }
}
