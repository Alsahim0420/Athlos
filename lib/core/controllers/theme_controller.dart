import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    // You can load saved theme preference here later
    currentThemeMode.value = ThemeMode.system;
  }

  void changeTheme(ThemeMode themeMode) {
    currentThemeMode.value = themeMode;
    Get.changeThemeMode(themeMode);
  }

  void toggleTheme() {
    if (currentThemeMode.value == ThemeMode.light) {
      changeTheme(ThemeMode.dark);
    } else if (currentThemeMode.value == ThemeMode.dark) {
      changeTheme(ThemeMode.system);
    } else {
      changeTheme(ThemeMode.light);
    }
  }

  String getThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  IconData getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
