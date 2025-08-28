import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/core/dependencies/dependency_injection.dart';
import 'app/core/constants/app_theme.dart';
import 'app/core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await DependencyInjection.init();
  
  // Check if user is already logged in
  final authService = Get.find<AuthService>();
  
  // Wait for AuthService to finish loading data
  await authService.onInit();
  
  String initialRoute;
  
  if (authService.isLoggedIn) {
    // User is logged in, go to main app
    initialRoute = AppPages.HOME;
    print('🏠 User already logged in, redirecting to main app');
  } else {
    // User not logged in, go to login page
    initialRoute = AppPages.INITIAL;
    print('🔐 User not logged in, redirecting to login page');
  }
  
  runApp(
    GetMaterialApp(
      title: "Snappie App",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Uncomment when dark theme is implemented
    ),
  );
}
