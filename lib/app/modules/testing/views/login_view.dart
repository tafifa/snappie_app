import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class TestingLoginView extends StatelessWidget {
  TestingLoginView({Key? key}) : super(key: key);

  final RxString _selectedMode = 'menu'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Obx(() {
          if (_selectedMode.value == 'menu') {
            return _buildModeSelector(context);
          } else if (_selectedMode.value == 'testing') {
            return _buildTestingLogin(context);
          } else {
            // Release mode - navigate to onboarding
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAllNamed('/login');
            });
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }

  Widget _buildModeSelector(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo/Title
            const Icon(
              Icons.location_on,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Snappie',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select Mode',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 64),

            // Testing Mode Button
            ElevatedButton(
              onPressed: () => _selectedMode.value = 'testing',
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.bug_report, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Testing Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Release Mode Button
            ElevatedButton(
              onPressed: () => _selectedMode.value = 'release',
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.rocket_launch, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Release Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: const [
                  Text(
                    'Testing Mode: Login with development features',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Release Mode: Start with onboarding flow',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildTestingLogin(BuildContext context) {
  final controller = Get.find<TestingAuthController>();

  return Column(
    children: [
      // Back Button Container (header)
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _selectedMode.value = 'menu',
            ),
            const Text(
              'Testing Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),

      // Expanded Login Section
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade300),
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
        
              // Login Button with Google
              Obx(() => _buildLoginButton(
                    isLoading: controller.isLoading,
                    onPressed: controller.loginWithGoogle,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                    text: 'Continue with Google',
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          'G',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),
        
              const Divider(height: 48),
        
              // Email Input
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
        
              const SizedBox(height: 8),
        
              // Login Button
              Obx(() => _buildLoginButton(
                    isLoading: controller.isLoading,
                    onPressed: controller.login,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    text: 'Login with Email',
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  )),
        
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ],
  );
}


  Widget _buildLoginButton({
    required bool isLoading,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
    required Widget icon,
    required String text,
    BorderSide? borderSide,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
