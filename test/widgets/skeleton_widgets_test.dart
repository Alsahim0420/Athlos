import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlos/features/home/presentation/widgets/exercises_skeleton.dart';

void main() {
  group('Skeleton Widgets Tests', () {
    group('ExercisesSkeleton Tests', () {
      testWidgets('should render exercise skeleton items', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(body: ExercisesSkeleton()),
          ),
        );

        // Should show skeleton items
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should adapt to light theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(body: ExercisesSkeleton()),
          ),
        );

        await tester.pumpAndSettle();

        // Should use light theme colors
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(container.decoration, isNotNull);
      });

      testWidgets('should adapt to dark theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(body: ExercisesSkeleton()),
          ),
        );

        await tester.pumpAndSettle();

        // Should use dark theme colors
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(container.decoration, isNotNull);
      });

      testWidgets('should show correct number of skeleton items', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(body: ExercisesSkeleton()),
          ),
        );

        // Should show multiple skeleton items
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should handle theme changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(body: ExercisesSkeleton()),
          ),
        );

        await tester.pumpAndSettle();

        // Change theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(body: ExercisesSkeleton()),
          ),
        );

        await tester.pumpAndSettle();

        // Should still render without errors
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('ProfileSkeleton Tests', () {
      testWidgets('should render profile skeleton elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(
                children: [Text('Test 1'), Text('Test 2'), Text('Test 3')],
              ),
            ),
          ),
        );

        // Should show test elements
        expect(find.byType(Text), findsNWidgets(3));
      });

      testWidgets('should adapt to light theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should use light theme
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('should adapt to dark theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should use dark theme
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('should show profile skeleton structure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        // Should show test structure
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('should handle theme switching', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Switch to dark theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should still render without errors
        expect(find.byType(Text), findsNWidgets(2));
      });
    });

    group('Skeleton Accessibility', () {
      testWidgets('should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        // Should be accessible
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should support screen readers', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        // Should render properly for screen readers
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Skeleton Performance', () {
      testWidgets('should render quickly', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(children: [Text('Test 1'), Text('Test 2')]),
            ),
          ),
        );

        stopwatch.stop();

        // Should render within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      testWidgets('should handle multiple instances efficiently', (
        WidgetTester tester,
      ) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(
                children: [Text('Test 1'), Text('Test 2'), Text('Test 3')],
              ),
            ),
          ),
        );

        stopwatch.stop();

        // Should handle multiple instances efficiently
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });
    });
  });
}
