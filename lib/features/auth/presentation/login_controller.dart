import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/auth_service.dart';
import '../data/services/session_service.dart';
import '../data/services/firestore_service.dart';

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
      UserCredential? userCredential;
      try {
        userCredential = await _authService.signInWithEmailAndPassword(
          email,
          password,
        );
        debugPrint('🔍 [LOGIN] Firebase Auth login successful!');
      } catch (authError) {
        debugPrint('🔄 [LOGIN] Auth error caught: $authError');

        // Handle the special case where user was signed in but Firebase returned an error
        if (authError.toString().contains(
          'USER_SIGNED_IN_BUT_FIREBASE_ERROR',
        )) {
          debugPrint(
            '🔄 [LOGIN] Firebase Auth error but user was signed in, continuing...',
          );
          final currentUser = _authService.currentUser;
          if (currentUser != null) {
            debugPrint('🔄 [LOGIN] Found current user: ${currentUser.uid}');
            // Use the current user directly
            userCredential = null; // We'll handle this case differently
            debugPrint('🔄 [LOGIN] Using current user for login details');
          } else {
            throw 'No se pudo obtener el usuario autenticado';
          }
        } else if (authError.toString().contains('PigeonUserDetails')) {
          // Handle PigeonUserDetails error specifically
          debugPrint(
            '🔄 [LOGIN] PigeonUserDetails error detected, checking current user...',
          );
          final currentUser = _authService.currentUser;
          if (currentUser != null) {
            debugPrint(
              '🔄 [LOGIN] Found current user despite PigeonUserDetails error: ${currentUser.uid}',
            );
            userCredential = null;
            debugPrint('🔄 [LOGIN] Using current user for login details');
          } else {
            throw 'Error de PigeonUserDetails: No se pudo obtener el usuario autenticado';
          }
        } else {
          rethrow;
        }
      }

      // Get user info either from UserCredential or currentUser
      String userId;
      String userEmail;

      if (userCredential != null) {
        userId = userCredential.user!.uid;
        userEmail = userCredential.user!.email!;
      } else {
        // Use currentUser if UserCredential is null (PigeonUserDetails error case)
        final currentUser = _authService.currentUser;
        if (currentUser != null) {
          userId = currentUser.uid;
          userEmail = currentUser.email!;
        } else {
          throw 'Error inesperado: No se pudo obtener la información del usuario para el login.';
        }
      }

      // Get complete user data from Firestore
      debugPrint(
        '🔍 [LOGIN] Fetching user data from Firestore for UID: $userId',
      );
      final firestoreService = FirestoreService();
      final userModel = await firestoreService.getUser(userId);

      if (userModel != null) {
        debugPrint(
          '✅ [LOGIN] User data found in Firestore: ${userModel.fullName}',
        );
        // Save complete user session
        await SessionService().saveUserSession(user: userModel);
        debugPrint('🔐 [LOGIN] Complete user session saved to Hive');
      } else {
        debugPrint(
          '⚠️ [LOGIN] No user data found in Firestore, using basic session',
        );
        // Fallback to basic session if Firestore data not available
        await SessionService().saveLoginSession(
          userId: userId,
          email: userEmail,
        );
        debugPrint(
          '🔐 [LOGIN] Basic session saved to Hive (no Firestore data)',
        );
      }

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
