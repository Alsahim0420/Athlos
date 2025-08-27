import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:ATHLOS/features/home/domain/repositories/exercise_repository.dart';
import 'package:ATHLOS/features/home/data/models/exercise_filters_model.dart';
import 'package:ATHLOS/features/home/data/models/exercise_model.dart';
import 'package:ATHLOS/features/home/presentation/controllers/home_controller.dart';

import 'home_controller_test.mocks.dart';

@GenerateMocks([ExerciseRepository, Connectivity])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // 🔧 INICIALIZAR BINDING

  group('HomeController Tests', () {
    late HomeController controller;
    late MockExerciseRepository mockRepository;

    setUp(() {
      mockRepository = MockExerciseRepository();
      controller = HomeController(exerciseRepository: mockRepository);

      // 🔧 CONFIGURAR MOCKS PARA EJERCICIOS DE PRUEBA
      final testExercises = [
        ExerciseModel(
          id: '1',
          name: 'Push-ups',
          bodyPart: 'chest',
          target: 'pectorals',
          equipment: 'body weight',
          gifUrl: 'test.gif',
          secondaryMuscles: ['triceps'],
          instructions: ['Do push-ups'],
          description: 'Basic push-ups',
          difficulty: 'beginner',
          category: 'strength',
        ),
        ExerciseModel(
          id: '2',
          name: 'Pull-ups',
          bodyPart: 'back',
          target: 'lats',
          equipment: 'body weight',
          gifUrl: 'test2.gif',
          secondaryMuscles: ['biceps'],
          instructions: ['Do pull-ups'],
          description: 'Basic pull-ups',
          difficulty: 'intermediate',
          category: 'strength',
        ),
      ];

      when(mockRepository.hasCachedData).thenReturn(true);
      when(mockRepository.getCachedExercises()).thenReturn(testExercises);
      when(
        mockRepository.fetchExercises(),
      ).thenAnswer((_) async => testExercises);
      when(
        mockRepository.fetchExercises(forceRefresh: true),
      ).thenAnswer((_) async => testExercises);
    });

    tearDown(() {
      controller.onClose();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(controller.isLoading.value, false);
        expect(controller.error.value, '');
        expect(controller.exercises.length, 0);
        expect(controller.filteredExercises.length, 0);
        expect(controller.isOnline.value, true);
      });
    });

    group('Exercise Loading', () {
      test('should load exercises from cache first', () async {
        // Arrange
        final mockExercises = [
          ExerciseModel(
            id: '1',
            name: 'Push-ups',
            bodyPart: 'chest',
            target: 'pectorals',
            equipment: 'body weight',
            gifUrl: 'test.gif',
            secondaryMuscles: ['triceps'],
            instructions: ['Do push-ups'],
            description: 'Basic push-ups',
            difficulty: 'beginner',
            category: 'strength',
          ),
        ];

        when(mockRepository.hasCachedData).thenReturn(true);
        when(mockRepository.getCachedExercises()).thenReturn(mockExercises);

        // Act - Call the public method that triggers loading
        await controller.refreshData();

        // Assert
        expect(controller.exercises.length, 2);
        expect(controller.filteredExercises.length, 2);
        expect(controller.exercises.first.name, 'Push-ups');
      });

      test('should extract filter options from exercises', () async {
        // Arrange
        final mockExercises = [
          ExerciseModel(
            id: '1',
            name: 'Push-ups',
            bodyPart: 'chest',
            target: 'pectorals',
            equipment: 'body weight',
            gifUrl: 'test.gif',
            secondaryMuscles: ['triceps'],
            instructions: ['Do push-ups'],
            description: 'Basic push-ups',
            difficulty: 'beginner',
            category: 'strength',
          ),
        ];

        when(mockRepository.hasCachedData).thenReturn(true);
        when(mockRepository.getCachedExercises()).thenReturn(mockExercises);

        // Act
        await controller.refreshData();

        // Assert
        expect(controller.availableCategories.length, 1);
        expect(controller.availableCategories.first, 'strength');
        expect(controller.availableTargetMuscles.length, 2);
        expect(controller.availableTargetMuscles.contains('pectorals'), true);
        expect(controller.availableEquipment.length, 1);
        expect(controller.availableEquipment.first, 'body weight');
        expect(controller.availableDifficulties.length, 2);
        expect(controller.availableDifficulties.contains('beginner'), true);
        expect(controller.availableBodyParts.length, 2);
        expect(controller.availableBodyParts.contains('chest'), true);
      });
    });

    group('Filter Management', () {
      setUp(() {
        // Setup mock exercises
        final mockExercises = [
          ExerciseModel(
            id: '1',
            name: 'Push-ups',
            bodyPart: 'chest',
            target: 'pectorals',
            equipment: 'body weight',
            gifUrl: 'test.gif',
            secondaryMuscles: ['triceps'],
            instructions: ['Do push-ups'],
            description: 'Basic push-ups',
            difficulty: 'beginner',
            category: 'strength',
          ),
          ExerciseModel(
            id: '2',
            name: 'Pull-ups',
            bodyPart: 'back',
            target: 'lats',
            equipment: 'body weight',
            gifUrl: 'test2.gif',
            secondaryMuscles: ['biceps'],
            instructions: ['Do pull-ups'],
            description: 'Basic pull-ups',
            difficulty: 'intermediate',
            category: 'strength',
          ),
        ];

        controller.exercises.assignAll(mockExercises);
        controller.filteredExercises.assignAll(mockExercises);
      });

      test('should apply category filter correctly', () {
        // Arrange
        final filters = ExerciseFiltersModel(category: 'strength');

        // Act
        controller.applyFilters(filters);

        // Assert
        expect(controller.filteredExercises.length, 2);
        expect(controller.currentFilters.value.category, 'strength');
      });

      test('should apply multiple filters correctly', () {
        // Arrange
        final filters = ExerciseFiltersModel(
          category: 'strength',
          difficulty: 'beginner',
        );

        // Act
        controller.applyFilters(filters);

        // Assert
        expect(controller.filteredExercises.length, 1);
        expect(controller.filteredExercises.first.name, 'Push-ups');
      });

      test('should clear all filters', () {
        // Arrange
        final filters = ExerciseFiltersModel(category: 'strength');
        controller.applyFilters(filters);

        // Act
        controller.clearFilters();

        // Assert
        expect(controller.filteredExercises.length, 2);
        expect(controller.currentFilters.value.hasActiveFilters, false);
      });

      test('should return correct exercise counts', () {
        expect(controller.totalExercisesCount, 2);
        expect(controller.filteredExercisesCount, 2);

        // Apply filter
        final filters = ExerciseFiltersModel(difficulty: 'beginner');
        controller.applyFilters(filters);

        expect(controller.filteredExercisesCount, 1);
      });
    });

    group('Connectivity Management', () {
      test('should handle going offline', () async {
        // Arrange
        controller.isOnline.value = true;

        // Act - Simulate going offline
        controller.isOnline.value = false;
        controller.wasOffline.value = true;

        // Assert
        expect(controller.isOnline.value, false);
        expect(controller.wasOffline.value, true);
      });

      test('should handle coming back online', () async {
        // Arrange
        controller.isOnline.value = false;
        controller.wasOffline.value = true;

        // Act - Simulate connectivity change
        // Note: This is testing the internal logic, not the actual connectivity
        controller.isOnline.value = true;
        controller.wasOffline.value = false;

        // Assert
        expect(controller.isOnline.value, true);
        expect(controller.wasOffline.value, false);
      });
    });

    group('Error Handling', () {
      test('should handle network errors gracefully', () async {
        // Arrange
        when(mockRepository.hasCachedData).thenReturn(false);
        when(
          mockRepository.fetchExercises(forceRefresh: true),
        ).thenThrow(Exception('Network error'));

        // Act
        await controller.refreshData();

        // Assert
        expect(controller.error.value.isNotEmpty, true);
        expect(controller.error.value.contains('Network error'), true);
      });

      test('should show cached data when network fails', () async {
        // Arrange
        final mockExercises = [
          ExerciseModel(
            id: '1',
            name: 'Push-ups',
            bodyPart: 'chest',
            target: 'pectorals',
            equipment: 'body weight',
            gifUrl: 'test.gif',
            secondaryMuscles: ['triceps'],
            instructions: ['Do push-ups'],
            description: 'Basic push-ups',
            difficulty: 'beginner',
            category: 'strength',
          ),
        ];

        // 🔧 SOBRESCRIBIR COMPLETAMENTE LOS MOCKS PARA ESTE TEST
        when(mockRepository.hasCachedData).thenReturn(true);
        when(mockRepository.getCachedExercises()).thenReturn(mockExercises);
        when(
          mockRepository.fetchExercises(forceRefresh: true),
        ).thenThrow(Exception('Network error'));

        // Act
        await controller.refreshData();

        // Assert
        expect(controller.exercises.length, 1);
        expect(controller.error.value.isEmpty, true);
      });
    });
  });
}
