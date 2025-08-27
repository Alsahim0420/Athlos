import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'controllers/home_controller.dart';
import '../domain/entities/exercise_entity.dart';
import '../domain/repositories/exercise_repository.dart';
import '../data/repositories/exercise_repository_impl.dart';
import '../data/datasources/exercise_remote_datasource.dart';
import '../data/models/exercise_model.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure all dependencies are available
    if (!Get.isRegistered<ExerciseRepository>()) {
      debugPrint('🏠 [HOMEPAGE] ExerciseRepository not found, creating it...');

      // Use the box that should already be open from main.dart
      final box = Hive.box<ExerciseModel>('exercises');
      debugPrint('🏠 [HOMEPAGE] Using existing Hive box: ${box.isOpen}');

      Get.put(
        ExerciseRepositoryImpl(
          remoteDataSource: ExerciseRemoteDataSourceImpl(client: http.Client()),
          box: box,
        ),
      );
    }

    if (!Get.isRegistered<HomeController>()) {
      debugPrint('🏠 [HOMEPAGE] HomeController not found, creating it...');
      Get.put(
        HomeController(exerciseRepository: Get.find<ExerciseRepository>()),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATHLOS'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/profile'),
            icon: const Icon(Icons.person),
            tooltip: 'Mi Perfil',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: Column(
          children: [
            // Exercise list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError && !controller.hasExercises) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar ejercicios',
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.error.value,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.refreshData,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (!controller.hasExercises) {
                  return const Center(
                    child: Text('No hay ejercicios disponibles'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = controller.exercises[index];
                    return _buildExerciseTile(exercise, theme);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTile(ExerciseEntity exercise, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 60,
            height: 60,
            child: Image.network(
              exercise.gifUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: theme.colorScheme.onSurface,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
        ),
        title: Text(
          exercise.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${exercise.bodyPart} • ${exercise.target} • ${exercise.equipment}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
        onTap: () {
          // TODO: Navigate to exercise detail page
          Get.snackbar(
            'Ejercicio',
            'Seleccionaste: ${exercise.name}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
      ),
    );
  }
}
