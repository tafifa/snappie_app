import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Only register HomeController
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
