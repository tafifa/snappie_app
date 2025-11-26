import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/core/constants/app_colors.dart';
import 'package:snappie_app/app/routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Masuk dengan Google Button
                    Obx(() => ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : controller.loginWithGoogle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA500),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Masuk dengan Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        )),

                    const SizedBox(height: 12),

                    // Daftar dengan Google Button
                    Obx(() => OutlinedButton(
                          onPressed: controller.isLoading
                              ? null
                              : controller.signUpWithGoogle,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFFA500),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Color(0xFFFFA500),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            disabledForegroundColor: Colors.grey.shade400,
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  ),
                                )
                              : const Text(
                                  'Daftar dengan Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        )),

                    const SizedBox(height: 24),

                    // Terms and Conditions Text
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'Dengan menggunakan aplikasi Snappie, saya setuju dengan ',
                          ),
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(AppPages.TNC);
                              },
                          ),
                          const TextSpan(
                            text:
                              ', termasuk ',
                          ),
                          TextSpan(
                            text: ' Kebijakan Privasi',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(AppPages.TNC);
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
