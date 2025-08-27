import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // App title
              Text(
                'ATHLOS',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: const Color(0xFFFFD600),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.0,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Welcome back!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Email field
              Obx(
                () => TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: theme.textTheme.bodyLarge?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    errorText: controller.emailError.value.isEmpty
                        ? null
                        : controller.emailError.value,
                  ),
                  onChanged: (value) {
                    if (controller.emailError.value.isNotEmpty) {
                      controller.emailError.value = '';
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Password field
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: theme.textTheme.bodyLarge?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    errorText: controller.passwordError.value.isEmpty
                        ? null
                        : controller.passwordError.value,
                  ),
                  onChanged: (value) {
                    if (controller.passwordError.value.isNotEmpty) {
                      controller.passwordError.value = '';
                    }
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Login button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Register button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: controller.register,
                  child: const Text('Don\'t have an account? Sign up'),
                ),
              ),

              const Spacer(),

              // Footer text
              Text(
                '© 2025 ATHLOS. All rights reserved.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.5,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
