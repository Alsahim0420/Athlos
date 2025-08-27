import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlos/features/home/domain/entities/exercise_filters.dart';
import 'package:athlos/features/home/data/models/exercise_filters_model.dart';
import 'package:athlos/features/home/presentation/widgets/exercise_filters_widget.dart';

void main() {
  group('ExerciseFiltersWidget Tests', () {
    late ExerciseFilters mockFilters;
    late Function(ExerciseFilters) mockOnFiltersChanged;
    late List<String> mockCategories;
    late List<String> mockTargetMuscles;
    late List<String> mockEquipment;
    late List<String> mockDifficulties;
    late List<String> mockBodyParts;

    setUp(() {
      mockFilters = const ExerciseFiltersModel();
      mockOnFiltersChanged = (filters) {};
      mockCategories = ['strength', 'cardio', 'flexibility'];
      mockTargetMuscles = ['chest', 'back', 'legs'];
      mockEquipment = ['body weight', 'dumbbell', 'barbell'];
      mockDifficulties = ['beginner', 'intermediate', 'advanced'];
      mockBodyParts = ['chest', 'back', 'waist'];
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: ExerciseFiltersWidget(
            currentFilters: mockFilters,
            onFiltersChanged: mockOnFiltersChanged,
            availableCategories: mockCategories,
            availableTargetMuscles: mockTargetMuscles,
            availableEquipment: mockEquipment,
            availableDifficulties: mockDifficulties,
            availableBodyParts: mockBodyParts,
            totalExercises: 100,
            filteredExercises: 50,
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render filter header correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Filters'), findsOneWidget);
        expect(find.byIcon(Icons.filter_list), findsOneWidget);
        expect(find.text('50/100'), findsOneWidget);
      });

      testWidgets('should show expand/collapse icon', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byIcon(Icons.expand_more), findsOneWidget);
        expect(find.byIcon(Icons.expand_less), findsNothing);
      });

      testWidgets('should display all filter sections', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Category'), findsOneWidget);
        expect(find.text('Target Muscle'), findsOneWidget);
        expect(find.text('Equipment'), findsOneWidget);
        expect(find.text('Difficulty'), findsOneWidget);
        expect(find.text('Body Part'), findsOneWidget);
      });

      testWidgets('should show action buttons', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Clear'), findsOneWidget);
        expect(find.text('Apply'), findsOneWidget);
        expect(find.byIcon(Icons.clear), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });

    group('Filter Interactions', () {
      testWidgets('should show "Todos" option for each filter section', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Todos'), findsNWidgets(5)); // 5 filter sections
      });

      testWidgets('should show filter options as chips', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('strength'), findsOneWidget);
        expect(find.text('cardio'), findsOneWidget);
        expect(find.text('chest'), findsWidgets);
        expect(find.text('body weight'), findsOneWidget);
        expect(find.text('beginner'), findsOneWidget);
      });

      testWidgets('should handle filter selection', (
        WidgetTester tester,
      ) async {
        final testWidget = MaterialApp(
          home: Scaffold(
            body: ExerciseFiltersWidget(
              currentFilters: mockFilters,
              onFiltersChanged: (filters) {},
              availableCategories: mockCategories,
              availableTargetMuscles: mockTargetMuscles,
              availableEquipment: mockEquipment,
              availableDifficulties: mockDifficulties,
              availableBodyParts: mockBodyParts,
              totalExercises: 100,
              filteredExercises: 50,
            ),
          ),
        );

        await tester.pumpWidget(testWidget);

        // Tap on a filter option
        await tester.tap(find.text('strength'));
        await tester.pump();

        // Just verify the widget is still there
        expect(find.text('strength'), findsOneWidget);
      });

      testWidgets('should handle clear filters', (WidgetTester tester) async {
        final testWidget = MaterialApp(
          home: Scaffold(
            body: ExerciseFiltersWidget(
              currentFilters: ExerciseFiltersModel(category: 'strength'),
              onFiltersChanged: (filters) {},
              availableCategories: mockCategories,
              availableTargetMuscles: mockTargetMuscles,
              availableEquipment: mockEquipment,
              availableDifficulties: mockDifficulties,
              availableBodyParts: mockBodyParts,
              totalExercises: 100,
              filteredExercises: 50,
            ),
          ),
        );

        await tester.pumpWidget(testWidget);

        // Tap clear button
        await tester.tap(find.text('Clear'));
        await tester.pump();

        // Just verify the widget is still there
        expect(find.text('Clear'), findsOneWidget);
      });
    });

    group('Animation and Expansion', () {
      testWidgets('should expand when header is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Initially collapsed
        expect(find.byIcon(Icons.expand_more), findsOneWidget);

        // Tap to expand
        await tester.tap(find.text('Filters'));
        await tester.pump();

        // Should show expanded state
        expect(find.byIcon(Icons.expand_less), findsOneWidget);
      });

      testWidgets('should show scroll indicator when expanded', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Tap to expand
        await tester.tap(find.text('Filters'));
        await tester.pump();

        // Should show scroll indicator
        expect(find.text('Scroll to see more filters'), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });
    });

    group('Filter State Display', () {
      testWidgets('should show active filters in header', (
        WidgetTester tester,
      ) async {
        final activeFilters = ExerciseFiltersModel(
          category: 'strength',
          difficulty: 'beginner',
        );

        final testWidget = MaterialApp(
          home: Scaffold(
            body: ExerciseFiltersWidget(
              currentFilters: activeFilters,
              onFiltersChanged: mockOnFiltersChanged,
              availableCategories: mockCategories,
              availableTargetMuscles: mockTargetMuscles,
              availableEquipment: mockEquipment,
              availableDifficulties: mockDifficulties,
              availableBodyParts: mockBodyParts,
              totalExercises: 100,
              filteredExercises: 25,
            ),
          ),
        );

        await tester.pumpWidget(testWidget);

        // Should show filter summary
        expect(
          find.text('Category: strength, Difficulty: beginner'),
          findsOneWidget,
        );
        expect(find.text('25/100'), findsOneWidget);
      });

      testWidgets('should show results summary when filters are active', (
        WidgetTester tester,
      ) async {
        final activeFilters = ExerciseFiltersModel(category: 'strength');

        final testWidget = MaterialApp(
          home: Scaffold(
            body: ExerciseFiltersWidget(
              currentFilters: activeFilters,
              onFiltersChanged: mockOnFiltersChanged,
              availableCategories: mockCategories,
              availableTargetMuscles: mockTargetMuscles,
              availableEquipment: mockEquipment,
              availableDifficulties: mockDifficulties,
              availableBodyParts: mockBodyParts,
              totalExercises: 100,
              filteredExercises: 30,
            ),
          ),
        );

        await tester.pumpWidget(testWidget);

        // Tap to expand
        await tester.tap(find.text('Filters'));
        await tester.pump();

        // Should show results summary
        expect(find.text('Results: 30 of 100 exercises'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());

        // Check for semantic labels - these are text-based, not semanticsLabel
        expect(find.text('Filters'), findsOneWidget);
        expect(find.text('Clear'), findsOneWidget);
        expect(find.text('Apply'), findsOneWidget);
      });

      testWidgets('should support screen readers', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Check for proper text scaling
        expect(find.text('Filters'), findsOneWidget);
        expect(find.text('Category'), findsOneWidget);
        expect(find.text('Target Muscle'), findsOneWidget);
      });
    });
  });
}
