import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/auth_service.dart';
import '../data/services/session_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = RxString('');
  final passwordError = RxString('');
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Email validation
  bool _validateEmail(String email) {
    if (email.isEmpty) {
      emailError.value = 'El correo electrónico es requerido';
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emailError.value = 'Por favor ingresa un correo válido';
      return false;
    }

    emailError.value = '';
    return true;
  }

  // Password validation
  bool _validatePassword(String password) {
    if (password.isEmpty) {
      passwordError.value = 'La contraseña es requerida';
      return false;
    }

    if (password.length < 6) {
      passwordError.value = 'La contraseña debe tener al menos 6 caracteres';
      return false;
    }

    passwordError.value = '';
    return true;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login method
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Clear previous errors
    emailError.value = '';
    passwordError.value = '';

    // Validate inputs first
    final isEmailValid = _validateEmail(email);
    final isPasswordValid = _validatePassword(password);

    if (!isEmailValid || !isPasswordValid) {
      // Show error snackbar for validation failures
      Get.snackbar(
        'Validation Error',
        'Please fix the errors above',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Show loading
    isLoading.value = true;

    try {
      // Call Firebase Auth
      final userCredential = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );

      // Save session to Hive
      await SessionService().saveLoginSession(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );

      // Hide loading
      isLoading.value = false;

      // Navigate to home
      Get.offAllNamed('/home');
    } catch (error) {
      // Hide loading
      isLoading.value = false;

      // Show error snackbar
      Get.snackbar(
        'Inicio de Sesión Fallido',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // Register method
  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Clear previous errors
    emailError.value = '';
    passwordError.value = '';

    // Validate inputs first
    final isEmailValid = _validateEmail(email);
    final isPasswordValid = _validatePassword(password);

    if (!isEmailValid || !isPasswordValid) {
      // Show error snackbar for validation failures
      Get.snackbar(
        'Validation Error',
        'Please fix the errors above',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Show loading
    isLoading.value = true;

    try {
      // Call Firebase Auth
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email,
        password,
      );

      // Save session to Hive
      await SessionService().saveLoginSession(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );

      // Hide loading
      isLoading.value = false;

      // Navigate to home
      Get.offAllNamed('/home');
    } catch (error) {
      // Hide loading
      isLoading.value = false;

      // Show error snackbar
      Get.snackbar(
        'Registration Failed',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _authService.signOut();

      // Clear session from Hive
      await SessionService().clearLoginSession();

      // Navigate to login
      Get.offAllNamed('/login');
    } catch (error) {
      Get.snackbar(
        'Logout Failed',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
