import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

/// Test configuration and utilities for ATHLOS app
class TestConfig {
  static Future<void> setupTestEnvironment() async {
    await setUpTestHive();

    // Initialize GetX for testing
    Get.testMode = true;

    // Register common services
    Get.put(TestThemeService());
  }

  static Future<void> tearDownTestEnvironment() async {
    await Hive.deleteFromDisk();
    Get.reset();
  }

  /// Creates a test MaterialApp with common configuration
  static Widget createTestApp({required Widget child, ThemeData? theme}) {
    return GetMaterialApp(
      home: child,
      theme: theme ?? ThemeData.light(),
      debugShowCheckedModeBanner: false,
    );
  }

  /// Creates a test Scaffold with common configuration
  static Widget createTestScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? drawer,
    Widget? endDrawer,
  }) {
    return Scaffold(
      appBar: appBar,
      body: body,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }

  /// Waits for animations to complete
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Taps a widget and waits for animations
  static Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await waitForAnimations(tester);
  }

  /// Scrolls and waits for animations
  static Future<void> scrollAndWait(
    WidgetTester tester,
    Finder finder,
    Offset offset,
    double velocity,
  ) async {
    await tester.fling(finder, offset, velocity);
    await waitForAnimations(tester);
  }
}

/// Mock theme service for testing
class TestThemeService extends GetxService {
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  Future<void> changeTheme(ThemeMode themeMode) async {
    _currentTheme = themeMode;
    Get.changeThemeMode(themeMode);
  }

  Future<void> loadTheme() async {
    // Mock implementation
  }
}

/// Common test data for exercises
class TestData {
  static List<Map<String, dynamic>> get mockExercises => [
    {
      'id': '1',
      'name': 'Push-ups',
      'bodyPart': 'chest',
      'target': 'pectorals',
      'equipment': 'body weight',
      'gifUrl': 'test.gif',
      'secondaryMuscles': ['triceps'],
      'instructions': ['Do push-ups'],
      'description': 'Basic push-ups',
      'difficulty': 'beginner',
      'category': 'strength',
    },
    {
      'id': '2',
      'name': 'Pull-ups',
      'bodyPart': 'back',
      'target': 'lats',
      'equipment': 'body weight',
      'gifUrl': 'test2.gif',
      'secondaryMuscles': ['biceps'],
      'instructions': ['Do pull-ups'],
      'description': 'Basic pull-ups',
      'difficulty': 'intermediate',
      'category': 'strength',
    },
  ];

  static List<String> get mockCategories => [
    'strength',
    'cardio',
    'flexibility',
  ];
  static List<String> get mockTargetMuscles => ['chest', 'back', 'legs'];
  static List<String> get mockEquipment => [
    'body weight',
    'dumbbell',
    'barbell',
  ];
  static List<String> get mockDifficulties => [
    'beginner',
    'intermediate',
    'advanced',
  ];
  static List<String> get mockBodyParts => ['chest', 'back', 'waist'];
}

/// Test matchers for common assertions
class TestMatchers {
  static Matcher hasText(String text) => findsOneWidget;
  static Matcher hasIcon(IconData icon) => findsOneWidget;
  static Matcher hasWidgetType(Type type) => findsOneWidget;
  static Matcher hasNoText(String text) => findsNothing;
  static Matcher hasNoIcon(IconData icon) => findsNothing;
  static Matcher hasNoWidgetType(Type type) => findsNothing;
}

/// Test utilities for common operations
class TestUtils {
  /// Finds text with exact match
  static Finder findText(String text) => find.text(text);

  /// Finds icon with exact match
  static Finder findIcon(IconData icon) => find.byIcon(icon);

  /// Finds widget by type
  static Finder findWidget<T>() => find.byType(T);

  /// Finds widget by key
  static Finder findKey(Key key) => find.byKey(key);

  /// Finds widget by predicate
  static Finder findWidgetByPredicate(bool Function(Widget) predicate) =>
      find.byWidgetPredicate(predicate);
}
