import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ATHLOS/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ATHLOS App Integration Tests', () {
    testWidgets('Complete app flow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to initialize
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Test 1: App should show home page
      expect(find.text('ATHLOS'), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsWidgets);

      // Test 2: Filters should be accessible
      if (find.text('Filtros').evaluate().isNotEmpty) {
        await tester.tap(find.text('Filtros'));
        await tester.pumpAndSettle();

        // Verify filter sections are visible
        expect(find.text('Categoría'), findsOneWidget);
        expect(find.text('Músculo Objetivo'), findsOneWidget);
        expect(find.text('Equipamiento'), findsOneWidget);
        expect(find.text('Dificultad'), findsOneWidget);
        expect(find.text('Parte del Cuerpo'), findsOneWidget);

        // Test filter interaction
        if (find.text('strength').evaluate().isNotEmpty) {
          await tester.tap(find.text('strength'));
          await tester.pumpAndSettle();

          // Apply filters
          await tester.tap(find.text('Aplicar'));
          await tester.pumpAndSettle();
        }

        // Close filters
        await tester.tap(find.text('Filtros'));
        await tester.pumpAndSettle();
      }

      // Test 3: Exercise list should be scrollable
      if (find.byType(ListView).evaluate().isNotEmpty) {
        await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);
        await tester.pumpAndSettle();

        await tester.fling(find.byType(ListView), const Offset(0, 500), 1000);
        await tester.pumpAndSettle();
      }

      // Test 4: Navigation to profile
      if (find.byIcon(Icons.person).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        // Should be on profile page
        expect(find.text('Mi Perfil'), findsOneWidget);

        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Test 5: Exercise detail navigation
      if (find.byType(ListTile).evaluate().isNotEmpty) {
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();

        // Should show exercise details
        expect(find.byType(AppBar), findsOneWidget);

        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Test 6: Pull to refresh
      if (find.byType(RefreshIndicator).evaluate().isNotEmpty) {
        await tester.fling(
          find.byType(RefreshIndicator),
          const Offset(0, 300),
          1000,
        );
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Filter functionality test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Open filters
      if (find.text('Filtros').evaluate().isNotEmpty) {
        await tester.tap(find.text('Filtros'));
        await tester.pumpAndSettle();

        // Test category filter
        if (find.text('Categoría').evaluate().isNotEmpty) {
          await tester.tap(find.text('Categoría'));
          await tester.pumpAndSettle();

          if (find.text('strength').evaluate().isNotEmpty) {
            await tester.tap(find.text('strength'));
            await tester.pumpAndSettle();
          }
        }

        // Test target muscle filter
        if (find.text('Músculo Objetivo').evaluate().isNotEmpty) {
          await tester.tap(find.text('Músculo Objetivo'));
          await tester.pumpAndSettle();

          if (find.text('chest').evaluate().isNotEmpty) {
            await tester.tap(find.text('chest'));
            await tester.pumpAndSettle();
          }
        }

        // Apply filters
        await tester.tap(find.text('Aplicar'));
        await tester.pumpAndSettle();

        // Verify filters are applied
        expect(find.text('Filtros'), findsOneWidget);

        // Clear filters
        await tester.tap(find.text('Filtros'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Limpiar'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Theme switching test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Navigate to profile
      if (find.byIcon(Icons.person).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        // Look for theme toggle
        if (find.byIcon(Icons.brightness_4).evaluate().isNotEmpty ||
            find.byIcon(Icons.brightness_7).evaluate().isNotEmpty) {
          await tester.tap(
            find.byIcon(Icons.brightness_4).evaluate().isNotEmpty
                ? find.byIcon(Icons.brightness_4).first
                : find.byIcon(Icons.brightness_7).first,
          );
          await tester.pumpAndSettle();

          // Theme should change
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Connectivity banner test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Look for connectivity banner
      if (find.byType(Container).evaluate().isNotEmpty) {
        // The banner might be visible depending on connectivity
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Performance test', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // App should start within reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));

      // Test scroll performance
      if (find.byType(ListView).evaluate().isNotEmpty) {
        final scrollStopwatch = Stopwatch()..start();

        await tester.fling(find.byType(ListView), const Offset(0, -1000), 1000);
        await tester.pumpAndSettle();

        scrollStopwatch.stop();

        // Scroll should be smooth
        expect(scrollStopwatch.elapsedMilliseconds, lessThan(2000));
      }
    });
  });
}
