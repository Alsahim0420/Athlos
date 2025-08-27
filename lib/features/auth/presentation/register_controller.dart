import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/auth_service.dart';
import '../data/services/firestore_service.dart';
import '../data/services/session_service.dart';
import '../data/models/user_model.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Controllers for form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  // Observable variables for errors
  final firstNameError = RxString('');
  final lastNameError = RxString('');
  final emailError = RxString('');
  final phoneError = RxString('');
  final passwordError = RxString('');
  final confirmPasswordError = RxString('');
  final ageError = RxString('');
  final weightError = RxString('');
  final heightError = RxString('');
  final genderError = RxString('');

  // Observable variables for form state
  final selectedGender = RxString('');
  final isLoading = false.obs;

  // Password validation states
  final hasMinLength = false.obs;
  final hasUppercase = false.obs;
  final hasLowercase = false.obs;
  final hasNumber = false.obs;
  final passwordsMatch = false.obs;

  // Password visibility states
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Password text states for real-time validation
  final confirmPasswordText = ''.obs;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.onClose();
  }

  // Validation methods
  bool _validateFirstName(String firstName) {
    if (firstName.isEmpty) {
      firstNameError.value = 'El nombre es requerido';
      return false;
    }
    if (firstName.length < 2) {
      firstNameError.value = 'El nombre debe tener al menos 2 caracteres';
      return false;
    }
    firstNameError.value = '';
    return true;
  }

  bool _validateLastName(String lastName) {
    if (lastName.isEmpty) {
      lastNameError.value = 'El apellido es requerido';
      return false;
    }
    if (lastName.length < 2) {
      lastNameError.value = 'El apellido debe tener al menos 2 caracteres';
      return false;
    }
    lastNameError.value = '';
    return true;
  }

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

  bool _validatePhone(String phone) {
    if (phone.isEmpty) {
      phoneError.value = 'El número de teléfono es requerido';
      return false;
    }
    if (phone.length < 10) {
      phoneError.value = 'El número de teléfono debe tener al menos 10 dígitos';
      return false;
    }
    phoneError.value = '';
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      passwordError.value = 'La contraseña es requerida';
      return false;
    }

    if (password.length < 6) {
      passwordError.value = 'La contraseña debe tener al menos 6 caracteres';
      return false;
    }

    // Update validation states for visual feedback
    hasMinLength.value = password.length >= 8;
    hasUppercase.value = password.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = password.contains(RegExp(r'[a-z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));

    passwordError.value = '';
    return true;
  }

  // Real-time password validation
  void validatePasswordRealTime(String password) {
    hasMinLength.value = password.length >= 6;
    hasUppercase.value = password.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = password.contains(RegExp(r'[a-z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));
  }

  // Real-time confirm password validation
  void validateConfirmPasswordRealTime(
    String password,
    String confirmPassword,
  ) {
    confirmPasswordText.value = confirmPassword;
    if (confirmPassword.isNotEmpty) {
      passwordsMatch.value = password == confirmPassword;
    } else {
      passwordsMatch.value = false;
    }
  }

  bool _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Confirma tu contraseña';
      passwordsMatch.value = false;
      return false;
    }

    if (password != confirmPassword) {
      confirmPasswordError.value = 'Las contraseñas no coinciden';
      passwordsMatch.value = false;
      return false;
    }

    passwordsMatch.value = true;
    confirmPasswordError.value = '';
    return true;
  }

  // Toggle password visibility methods
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool _validateAge(String age) {
    if (age.isEmpty) {
      ageError.value = 'La edad es requerida';
      return false;
    }
    final ageNum = int.tryParse(age);
    if (ageNum == null || ageNum < 13 || ageNum > 120) {
      ageError.value = 'La edad debe estar entre 13 y 120 años';
      return false;
    }
    ageError.value = '';
    return true;
  }

  bool _validateGender(String gender) {
    if (gender.isEmpty) {
      genderError.value = 'El género es requerido';
      return false;
    }
    genderError.value = '';
    return true;
  }

  bool _validateWeight(String weight) {
    if (weight.isEmpty) {
      weightError.value = 'El peso es requerido';
      return false;
    }
    final weightNum = double.tryParse(weight);
    if (weightNum == null || weightNum < 20 || weightNum > 300) {
      weightError.value = 'El peso debe estar entre 20 y 300 kg';
      return false;
    }
    weightError.value = '';
    return true;
  }

  bool _validateHeight(String height) {
    if (height.isEmpty) {
      heightError.value = 'La estatura es requerida';
      return false;
    }
    final heightNum = double.tryParse(height);
    if (heightNum == null || heightNum < 100 || heightNum > 250) {
      heightError.value = 'La estatura debe estar entre 100 y 250 cm';
      return false;
    }
    heightError.value = '';
    return true;
  }

  // Register method
  Future<void> register() async {
    // Clear previous errors
    firstNameError.value = '';
    lastNameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    ageError.value = '';
    weightError.value = '';
    heightError.value = '';
    genderError.value = '';

    // Get form values
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final age = ageController.text.trim();
    final weight = weightController.text.trim();
    final height = heightController.text.trim();
    final gender = selectedGender.value;

    // Validate all inputs
    final isFirstNameValid = _validateFirstName(firstName);
    final isLastNameValid = _validateLastName(lastName);
    final isEmailValid = _validateEmail(email);
    final isPhoneValid = _validatePhone(phone);
    final isPasswordValid = _validatePassword(password);
    final isConfirmPasswordValid = _validateConfirmPassword(
      password,
      confirmPassword,
    );
    final isAgeValid = _validateAge(age);
    final isGenderValid = _validateGender(gender);
    final isWeightValid = _validateWeight(weight);
    final isHeightValid = _validateHeight(height);

    if (!isFirstNameValid ||
        !isLastNameValid ||
        !isEmailValid ||
        !isPhoneValid ||
        !isPasswordValid ||
        !isConfirmPasswordValid ||
        !isAgeValid ||
        !isGenderValid ||
        !isWeightValid ||
        !isHeightValid) {
      // Show error snackbar for validation failures
      Get.snackbar(
        'Error de Validación',
        'Por favor corrige los errores de arriba',
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
      // Create user in Firebase Auth
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email,
        password,
      );

      // Create user model
      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        age: int.parse(age),
        weight: double.parse(weight),
        height: double.parse(height),
        gender: gender,
        birthDate: DateTime.now().subtract(
          Duration(days: int.parse(age) * 365),
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user to Firestore
      await _firestoreService.createUser(user);

      // Save session to Hive
      await SessionService().saveLoginSession(
        userId: user.uid,
        email: user.email,
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
        'Registro Fallido',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
