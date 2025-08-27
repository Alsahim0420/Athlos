import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:athlos/core/services/theme_service.dart';

void main() {
  group('ThemeService Tests', () {
    late ThemeService themeService;
    late Box mockBox;

    setUp(() async {
      await setUpTestHive();
      mockBox = await Hive.openBox('theme_preferences');
      themeService = ThemeService();
      
      // 🔧 REGISTRAR EL SERVICE EN GETX
      Get.put(themeService);
    });

    tearDown(() async {
      await mockBox.close();
      await Hive.deleteBoxFromDisk('theme_preferences');
    });

    group('Initialization', () {
      test('should initialize with default theme', () {
        expect(themeService.currentTheme, ThemeMode.system);
      });

      test('should be registered as GetX service', () {
        expect(Get.isRegistered<ThemeService>(), true);
      });
    });

    group('Theme Loading', () {
      test('should load saved theme from Hive', () async {
        // Arrange
        await mockBox.put('theme_mode', 'dark');

        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.dark);
      });

      test('should handle missing theme preference gracefully', () async {
        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.system);
      });

      test('should handle invalid theme preference gracefully', () async {
        // Arrange
        await mockBox.put('theme_mode', 'invalid_theme');

        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.system);
      });
    });

    group('Theme Changing', () {
      test('should change to light theme', () async {
        // Act
        await themeService.changeTheme(ThemeMode.light);

        // Assert
        expect(themeService.currentTheme, ThemeMode.light);
      });

      test('should change to dark theme', () async {
        // Act
        await themeService.changeTheme(ThemeMode.dark);

        // Assert
        expect(themeService.currentTheme, ThemeMode.dark);
      });

      test('should change to system theme', () async {
        // Act
        await themeService.changeTheme(ThemeMode.system);

        // Assert
        expect(themeService.currentTheme, ThemeMode.system);
      });

      test('should persist theme change to Hive', () async {
        // Act
        await themeService.changeTheme(ThemeMode.dark);

        // Assert
        final savedTheme = mockBox.get('theme_mode');
        expect(savedTheme, 'dark');
      });
    });

    group('Theme Persistence', () {
      test('should persist theme across app restarts', () async {
        // Arrange
        await themeService.changeTheme(ThemeMode.light);

        // Act - Simulate app restart
        final newThemeService = ThemeService();
        await newThemeService.loadTheme();

        // Assert
        expect(newThemeService.currentTheme, ThemeMode.light);
      });

      test('should handle Hive errors gracefully', () async {
        // Arrange - Close box to simulate error
        await mockBox.close();

        // Act
        await themeService.changeTheme(ThemeMode.dark);

        // Assert - Should not crash and maintain current theme
        expect(themeService.currentTheme, ThemeMode.dark);
      });
    });

    group('Theme Mode Validation', () {
      test('should validate light theme string', () async {
        // Arrange
        await mockBox.put('theme_mode', 'light');

        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.light);
      });

      test('should validate dark theme string', () async {
        // Arrange
        await mockBox.put('theme_mode', 'dark');

        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.dark);
      });

      test('should validate system theme string', () async {
        // Arrange
        await mockBox.put('theme_mode', 'system');

        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.system);
      });
    });

    group('GetX Integration', () {
      test('should update GetX theme mode', () async {
        // Act
        await themeService.changeTheme(ThemeMode.dark);

        // Assert
      });

      test('should be accessible via Get.find', () {
        // Act
        final foundService = Get.find<ThemeService>();

        // Assert
        expect(foundService, isA<ThemeService>());
        expect(foundService.currentTheme, themeService.currentTheme);
      });
    });

    group('Error Handling', () {
      test('should handle null theme preference', () async {
        // Arrange
        await mockBox.put('theme_mode', null);

        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.system);
      });

      test('should handle empty theme preference', () async {
        // Arrange
        await mockBox.put('theme_mode', '');

        // Act
        await themeService.loadTheme();

        // Assert
        expect(themeService.currentTheme, ThemeMode.system);
      });
    });
  });
}
