import 'package:get/get.dart';
import '../../../domain/usecases/user/get_current_user_usecase.dart';
import '../../../domain/usecases/user/get_users_usecase.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        getUsersUseCase: Get.find<GetUsersUseCase>(),
      ),
    );
  }
}
