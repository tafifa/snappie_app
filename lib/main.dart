import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snappie_app/app/core/dependencies/core_dependencies.dart';
import 'package:snappie_app/app/core/dependencies/data_dependencies.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/constants/app_theme.dart';

Future<String> initAuthService() async {
  try {
    final authService = Get.find<AuthService>();
    await authService.onInit();
    
    if (authService.isLoggedIn) {
      return AppPages.MAIN;
    }
    return AppPages.INITIAL;
  } catch (e) {
    print('Error initializing auth service: $e');
    return AppPages.INITIAL;
  }
}

void main() async {
  // Initialize bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize core dependencies (network, auth services, etc)
  await CoreDependencies.init();
  
  // Initialize data layer (datasources & repositories)
  await DataDependencies.init();

  runApp(MainApp(route: await initAuthService()));
}

class MainApp extends StatelessWidget {
  final String route;

  const MainApp({
    required this.route,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Snappie App",
          initialRoute: route,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          
          // Apply custom theme with Material Design color system
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
        );
      },
    );
  }
}
