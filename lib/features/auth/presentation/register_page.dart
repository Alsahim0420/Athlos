import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAllNamed('/login'),
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.appBarTheme.foregroundColor,
          ),
          tooltip: 'Back to login',
        ),
        title: const Text('Create Account'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App title
              Center(
                child: SizedBox(
                  width: 200,
                  child: Image.asset(
                    'assets/images/icon_text.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Center(
                child: Text(
                  'Join the community!',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Personal Information Section
              Text(
                'Personal Information',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // First Name and Last Name Row
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TextField(
                        controller: controller.firstNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Nombre',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: theme.textTheme.bodyLarge?.color?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          errorText: controller.firstNameError.value.isEmpty
                              ? null
                              : controller.firstNameError.value,
                        ),
                        onChanged: (value) {
                          if (controller.firstNameError.value.isNotEmpty) {
                            controller.firstNameError.value = '';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => TextField(
                        controller: controller.lastNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: theme.textTheme.bodyLarge?.color?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          errorText: controller.lastNameError.value.isEmpty
                              ? null
                              : controller.lastNameError.value,
                        ),
                        onChanged: (value) {
                          if (controller.lastNameError.value.isNotEmpty) {
                            controller.lastNameError.value = '';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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

              // Phone field
              Obx(
                () => TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: theme.textTheme.bodyLarge?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    errorText: controller.phoneError.value.isEmpty
                        ? null
                        : controller.phoneError.value,
                  ),
                  onChanged: (value) {
                    if (controller.phoneError.value.isNotEmpty) {
                      controller.phoneError.value = '';
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Password field
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: theme.textTheme.bodyLarge?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    errorText: controller.passwordError.value.isEmpty
                        ? null
                        : controller.passwordError.value,
                  ),
                  onChanged: (value) {
                    if (controller.passwordError.value.isNotEmpty) {
                      controller.passwordError.value = '';
                    }
                    controller.validatePasswordRealTime(value);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Password requirements
              Obx(
                () => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement(
                        'At least 6 characters',
                        controller.hasMinLength.value,
                        theme,
                      ),
                      _buildRequirement(
                        'One uppercase letter',
                        controller.hasUppercase.value,
                        theme,
                      ),
                      _buildRequirement(
                        'One lowercase letter',
                        controller.hasLowercase.value,
                        theme,
                      ),
                      _buildRequirement(
                        'One number',
                        controller.hasNumber.value,
                        theme,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Password field
              Obx(
                () => TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: theme.textTheme.bodyLarge?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                    errorText: controller.confirmPasswordError.value.isEmpty
                        ? null
                        : controller.confirmPasswordError.value,
                  ),
                  onChanged: (value) {
                    if (controller.confirmPasswordError.value.isNotEmpty) {
                      controller.confirmPasswordError.value = '';
                    }
                    controller.validateConfirmPasswordRealTime(
                      controller.passwordController.text,
                      value,
                    );
                  },
                ),
              ),

              // Password match indicator
              Obx(
                () => controller.confirmPasswordText.value.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: controller.passwordsMatch.value
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: controller.passwordsMatch.value
                                ? Colors.green.withValues(alpha: 0.3)
                                : Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.passwordsMatch.value
                                  ? Icons.check_circle
                                  : Icons.error_outline,
                              size: 16,
                              color: controller.passwordsMatch.value
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.passwordsMatch.value
                                  ? 'Passwords match'
                                  : 'Passwords do not match',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: controller.passwordsMatch.value
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 40),

              // Physical Information Section
              Text(
                'Physical Information',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // Age and Gender Row
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () => TextField(
                        controller: controller.ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Age',
                          prefixIcon: Icon(
                            Icons.cake_outlined,
                            color: theme.textTheme.bodyLarge?.color?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          errorText: controller.ageError.value.isEmpty
                              ? null
                              : controller.ageError.value,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) {
                          if (controller.ageError.value.isNotEmpty) {
                            controller.ageError.value = '';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedGender.value.isEmpty
                            ? null
                            : controller.selectedGender.value,
                        decoration: InputDecoration(
                          hintText: 'Gender',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: theme.textTheme.bodyLarge?.color?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          errorText: controller.genderError.value.isEmpty
                              ? null
                              : controller.genderError.value,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: ['Male', 'Female', 'Other']
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(
                                  gender == 'Male'
                                      ? 'Male'
                                      : gender == 'Female'
                                      ? 'Female'
                                      : 'Other',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedGender.value = value;
                            if (controller.genderError.value.isNotEmpty) {
                              controller.genderError.value = '';
                            }
                          }
                        },
                        isExpanded: true,
                        menuMaxHeight: 200,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Weight and Height Row
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () => TextField(
                        controller: controller.weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Weight (kg)',
                          prefixIcon: Icon(
                            Icons.monitor_weight_outlined,
                            color: theme.textTheme.bodyLarge?.color?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          errorText: controller.weightError.value.isEmpty
                              ? null
                              : controller.weightError.value,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) {
                          if (controller.weightError.value.isNotEmpty) {
                            controller.weightError.value = '';
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () => TextField(
                        controller: controller.heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Height (cm)',
                          prefixIcon: Icon(
                            Icons.height_outlined,
                            color: theme.textTheme.bodyLarge?.color?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          errorText: controller.heightError.value.isEmpty
                              ? null
                              : controller.heightError.value,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) {
                          if (controller.heightError.value.isNotEmpty) {
                            controller.heightError.value = '';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Register button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.register,
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
                        : const Text('Create Account'),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Back to login button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  child: const Text('Already have an account? Sign in'),
                ),
              ),

              const SizedBox(height: 30),

              // Footer text
              Center(
                child: Text(
                  '© 2025 ATHLOS. All rights reserved.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build password requirements
  Widget _buildRequirement(String text, bool isMet, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet
                ? Colors.green
                : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isMet
                  ? Colors.green
                  : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
