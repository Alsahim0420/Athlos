import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';

class HomeController extends GetxController {
  final ExerciseRepository _exerciseRepository;

  HomeController({required ExerciseRepository exerciseRepository})
    : _exerciseRepository = exerciseRepository;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<ExerciseEntity> exercises = <ExerciseEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🏠 [HOME_CONTROLLER] onInit() called');
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    debugPrint('🏠 [HOME_CONTROLLER] _loadExercises() called');
    try {
      debugPrint('🏠 [HOME_CONTROLLER] Setting loading to true');
      isLoading.value = true;
      error.value = '';

      debugPrint('🏠 [HOME_CONTROLLER] Calling repository.fetchExercises()...');
      final exerciseList = await _exerciseRepository.fetchExercises();
      debugPrint(
        '🏠 [HOME_CONTROLLER] Got ${exerciseList.length} exercises from repository',
      );

      debugPrint('🏠 [HOME_CONTROLLER] Assigning exercises to observable list');
      exercises.assignAll(exerciseList);
      debugPrint('🏠 [HOME_CONTROLLER] Exercises assigned successfully');
    } catch (e) {
      debugPrint('🏠 [HOME_CONTROLLER] Error loading exercises: $e');
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudieron cargar los ejercicios: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
      );
    } finally {
      debugPrint('🏠 [HOME_CONTROLLER] Setting loading to false');
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      error.value = '';

      final exerciseList = await _exerciseRepository.fetchExercises(
        forceRefresh: true,
      );
      exercises.assignAll(exerciseList);

      Get.snackbar(
        'Éxito',
        'Datos actualizados correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudieron actualizar los datos: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasError => error.value.isNotEmpty;
  bool get hasExercises => exercises.isNotEmpty;
}
