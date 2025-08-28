import 'package:get/get.dart';
import '../constants/environment_config.dart';

class EnvironmentService extends GetxService {
  @override
  void onInit() {
    super.onInit();
    // No need to load environment from storage - always use development
  }
  
  // Always return development environment
  String get currentEnvironment => 'development';
  
  // Always use API (no mock data)
  bool get useApi => true;
  
  // Get API configuration
  String get apiBaseUrl => EnvironmentConfig.baseUrl;
  String get apiVersion => EnvironmentConfig.apiVersion;
  String get fullApiUrl => EnvironmentConfig.fullApiUrl;
}
