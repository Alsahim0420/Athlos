import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'controllers/home_controller.dart';
import 'widgets/exercises_skeleton.dart';
import 'widgets/connectivity_banner.dart';
import 'pages/exercise_detail_page.dart';
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
        title: _buildAthlosTitle(theme),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          // Profile button
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
            // Connectivity banner
            Obx(
              () => ConnectivityBanner(
                isOnline: controller.isConnectivityBannerOnline.value,
                isVisible: controller.isConnectivityBannerVisible.value,
                onDismiss: controller.dismissConnectivityBanner,
              ),
            ),
            // Exercise list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const ExercisesSkeleton(itemCount: 8);
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
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.fitness_center,
            color: theme.colorScheme.onSurface,
            size: 28,
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
          Get.to(() => ExerciseDetailPage(exercise: exercise));
        },
      ),
    );
  }

  Widget _buildAthlosTitle(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Lightning bolt icon (yellow)
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.amber.shade600,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.flash_on, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        // ATHLOS text
        Text(
          'ATHLOS',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
