import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          // Ocultar teclado al tocar fuera
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 60),

                          // App title
                          SizedBox(
                            height: 200,
                            child: Image.asset(
                              'assets/images/icon_text.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '¡Bienvenido de vuelta!',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.textTheme.bodyLarge?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 60),

                          // Email field
                          TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Correo Electrónico',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withValues(alpha: 0.5),
                              ),
                              errorText: controller.emailError.value.isEmpty
                                  ? null
                                  : controller.emailError.value,
                            ),
                            onChanged: (_) {
                              if (controller.emailError.value.isNotEmpty) {
                                controller.emailError.value = '';
                              }
                            },
                          ),

                          const SizedBox(height: 20),

                          // Password field
                          Obx(
                            () => TextField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                hintText: 'Contraseña',
                                prefixIcon: Icon(
                                  Icons.lock_outlined,
                                  color: theme.textTheme.bodyLarge?.color
                                      ?.withValues(alpha: 0.5),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: theme.textTheme.bodyLarge?.color
                                        ?.withValues(alpha: 0.5),
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                                errorText:
                                    controller.passwordError.value.isEmpty
                                    ? null
                                    : controller.passwordError.value,
                              ),
                              onChanged: (_) {
                                if (controller.passwordError.value.isNotEmpty) {
                                  controller.passwordError.value = '';
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Login button
                          Obx(
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.black,
                                            ),
                                      ),
                                    )
                                  : const Text('Iniciar Sesión'),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: () => Get.offAllNamed('/register'),
                            child: const Text('¿No tienes cuenta? Regístrate'),
                          ),

                          const Spacer(),

                          Text(
                            '© 2025 ATHLOS. Todos los derechos reservados.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
