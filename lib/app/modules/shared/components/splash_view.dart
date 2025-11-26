import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/routes/app_pages.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to next screen after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.context != null) {
        Get.offAllNamed(AppPages.LOGIN); // Change this to your desired route
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(
              Icons.camera_alt,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            
            // App Name
            const Text(
              'Snappie',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline (optional)
            Text(
              'Capture & Share Moments',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}