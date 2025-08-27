import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = RxString('');
  final passwordError = RxString('');
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Email validation
  bool _validateEmail(String email) {
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emailError.value = 'Please enter a valid email';
      return false;
    }

    emailError.value = '';
    return true;
  }

  // Password validation
  bool _validatePassword(String password) {
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      return false;
    }

    if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      return false;
    }

    passwordError.value = '';
    return true;
  }

  // Login method
  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Clear previous errors
    emailError.value = '';
    passwordError.value = '';

    // Validate inputs
    final isEmailValid = _validateEmail(email);
    final isPasswordValid = _validatePassword(password);

    if (!isEmailValid || !isPasswordValid) {
      return;
    }

    // Show loading
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;

      // For now, just navigate to home
      // In real app, you would make API call here
      Get.offAllNamed('/home');
    });
  }

  // Register method
  void register() {
    // TODO: Implement registration navigation
    Get.snackbar(
      'Coming Soon',
      'Registration feature will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
