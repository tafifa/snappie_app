import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/google_auth_service.dart';

/// Binding untuk Auth module (Login & Register)
/// Controller permanent karena dipakai selama auth flow
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(
      AuthController(
        authService: Get.find<AuthService>(),
        googleAuthService: Get.find<GoogleAuthService>(),
      ),
      permanent: true,
    );
  }
}
