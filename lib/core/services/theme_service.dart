import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeService extends GetxService {
  final Rx<ThemeMode> _currentTheme = ThemeMode.system.obs;

  ThemeMode get currentTheme => _currentTheme.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎨 [THEME] ThemeService.onInit() called');
    // Load theme immediately and apply it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🎨 [THEME] PostFrameCallback executing, loading theme...');
      loadTheme();
    });
  }

  /// Loads the saved theme from Hive
  Future<void> loadTheme() async {
    debugPrint('🎨 [THEME] loadTheme() called');

    try {
      // Wait a bit for Hive to be ready
      await Future.delayed(const Duration(milliseconds: 300));

      debugPrint('🎨 [THEME] Loading theme from Hive...');
      await _loadThemeFromHive();

      // Apply the loaded theme
      Get.changeThemeMode(_currentTheme.value);
      debugPrint('🎨 [THEME] Theme loaded and applied: ${_currentTheme.value}');
    } catch (e) {
      debugPrint('❌ [THEME] Error loading theme: $e, using system theme');
      _currentTheme.value = ThemeMode.system;
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  /// Changes the theme and saves it to Hive
  Future<void> changeTheme(ThemeMode themeMode) async {
    debugPrint('🎨 [THEME] changeTheme() called with: $themeMode');
    try {
      _currentTheme.value = themeMode;
      debugPrint('🎨 [THEME] _currentTheme.value set to: $themeMode');
      Get.changeThemeMode(themeMode);
      debugPrint('🎨 [THEME] Get.changeThemeMode() called with: $themeMode');

      // Save to Hive
      await _saveThemeToHive(themeMode);
      debugPrint('🎨 [THEME] Theme saved to Hive: $themeMode');
    } catch (e) {
      debugPrint('❌ [THEME] Error changing theme: $e');
    }
  }

  /// Toggles between light and dark themes
  Future<void> toggleTheme() async {
    if (_currentTheme.value == ThemeMode.light) {
      await changeTheme(ThemeMode.dark);
    } else if (_currentTheme.value == ThemeMode.dark) {
      await changeTheme(ThemeMode.light);
    } else {
      // If system theme, default to light
      await changeTheme(ThemeMode.light);
    }
  }

  /// Gets the current theme name for display
  String getCurrentThemeName() {
    switch (_currentTheme.value) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  /// Gets the icon for the current theme
  IconData getCurrentThemeIcon() {
    switch (_currentTheme.value) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Forces the application of the current theme
  void forceApplyCurrentTheme() {
    Get.changeThemeMode(_currentTheme.value);
    debugPrint(
      '🎨 [THEME] Force applied current theme: ${_currentTheme.value}',
    );
  }

  /// Debug method to check current state
  void debugCurrentState() async {
    debugPrint('🎨 [THEME] === DEBUG CURRENT STATE ===');
    debugPrint('🎨 [THEME] _currentTheme.value: ${_currentTheme.value}');

    try {
      final box = await Hive.openBox('theme_preferences');
      final savedTheme = box.get('theme_mode') as String?;
      debugPrint('🎨 [THEME] Saved in Hive: "$savedTheme"');
    } catch (e) {
      debugPrint('🎨 [THEME] Error reading Hive: $e');
    }

    debugPrint('🎨 [THEME] === END DEBUG ===');
  }

  /// Fallback method using Hive if SharedPreferences fails
  Future<void> _saveThemeToHive(ThemeMode themeMode) async {
    try {
      final box = await Hive.openBox('theme_preferences');
      String themeString;

      switch (themeMode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }

      await box.put('theme_mode', themeString);
      debugPrint('🎨 [THEME] Saved theme to Hive: "$themeString"');
    } catch (e) {
      debugPrint('❌ [THEME] Error saving to Hive: $e');
    }
  }

  /// Load theme from Hive fallback
  Future<void> _loadThemeFromHive() async {
    try {
      final box = await Hive.openBox('theme_preferences');
      final themeString = box.get('theme_mode') as String?;

      if (themeString != null) {
        switch (themeString) {
          case 'light':
            _currentTheme.value = ThemeMode.light;
            break;
          case 'dark':
            _currentTheme.value = ThemeMode.dark;
            break;
          case 'system':
          default:
            _currentTheme.value = ThemeMode.system;
            break;
        }

        Get.changeThemeMode(_currentTheme.value);
        debugPrint('🎨 [THEME] Loaded theme from Hive: ${_currentTheme.value}');
      }
    } catch (e) {
      debugPrint('❌ [THEME] Error loading from Hive: $e');
    }
  }
}
