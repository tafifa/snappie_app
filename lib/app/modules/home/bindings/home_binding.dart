import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/services/auth_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(authService: Get.find<AuthService>()),
    );
  }
}
