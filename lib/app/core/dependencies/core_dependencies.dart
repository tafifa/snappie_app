import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/auth_service.dart';
import '../services/google_auth_service.dart';

/// Core dependencies yang selalu dibutuhkan di seluruh aplikasi
/// Diinisialisasi sekali saat app startup
class CoreDependencies {
  static Future<void> init() async {
    // Network & Connectivity
    Get.lazyPut<Connectivity>(() => Connectivity());
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
    Get.lazyPut<DioClient>(() => DioClient());
    
    // Auth Services - Permanent karena dipakai di banyak tempat
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<GoogleAuthService>(GoogleAuthService(), permanent: true);
  }
}
