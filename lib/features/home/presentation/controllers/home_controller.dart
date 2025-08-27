import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';

class HomeController extends GetxController {
  final ExerciseRepository _exerciseRepository;

  HomeController({required ExerciseRepository exerciseRepository})
    : _exerciseRepository = exerciseRepository;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<ExerciseEntity> exercises = <ExerciseEntity>[].obs;

  // Connectivity management
  final RxBool isOnline = true.obs;
  final RxBool wasOffline = false.obs;
  final RxBool isConnectivityBannerVisible = false.obs;
  final RxBool isConnectivityBannerOnline = true.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🏠 [HOME_CONTROLLER] onInit() called');

    // Initialize connectivity monitoring
    _initializeConnectivity();

    // Use addPostFrameCallback to avoid build-time errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExercises();
    });
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _loadExercises() async {
    debugPrint('🏠 [HOME_CONTROLLER] _loadExercises() called');
    try {
      debugPrint('🏠 [HOME_CONTROLLER] Setting loading to true');
      isLoading.value = true;
      error.value = '';

      // First, try to load from cache (offline-first approach)
      if (_exerciseRepository.hasCachedData) {
        debugPrint('🏠 [HOME_CONTROLLER] Loading cached exercises first...');
        final cachedExercises = _exerciseRepository.getCachedExercises();
        exercises.assignAll(cachedExercises);
        debugPrint(
          '🏠 [HOME_CONTROLLER] Loaded ${cachedExercises.length} exercises from cache',
        );

        // Show offline mode message only if we're actually offline
        if (!isOnline.value) {
          _showConnectivityBanner(isOnline: false);
        }
      }

      // Then try to fetch from network (background refresh)
      debugPrint('🏠 [HOME_CONTROLLER] Attempting network refresh...');
      try {
        final exerciseList = await _exerciseRepository.fetchExercises();
        debugPrint(
          '🏠 [HOME_CONTROLLER] Got ${exerciseList.length} exercises from network',
        );

        // Update the list with fresh data
        exercises.assignAll(exerciseList);
        debugPrint('🏠 [HOME_CONTROLLER] Exercises updated from network');
      } catch (networkError) {
        debugPrint('🏠 [HOME_CONTROLLER] Network failed: $networkError');

        // If we don't have cached data, show error
        if (!_exerciseRepository.hasCachedData) {
          error.value = networkError.toString();
          _showSnackbar(
            'Error de Conexión',
            'No se pudieron cargar los ejercicios: ${networkError.toString()}',
            isError: true,
          );
        } else {
          // We have cached data, so just show a warning
          _showConnectivityBanner(isOnline: false);
        }
      }
    } catch (e) {
      debugPrint('🏠 [HOME_CONTROLLER] Unexpected error: $e');
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Error inesperado: ${e.toString()}',
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

      debugPrint(
        '🏠 [HOME_CONTROLLER] refreshData() - Force refresh requested',
      );

      // Force refresh from network
      final exerciseList = await _exerciseRepository.fetchExercises(
        forceRefresh: true,
      );

      exercises.assignAll(exerciseList);
      debugPrint(
        '🏠 [HOME_CONTROLLER] refreshData() - Updated with fresh data',
      );
    } catch (e) {
      debugPrint('🏠 [HOME_CONTROLLER] refreshData() - Error: $e');

      // If refresh fails, try to show cached data
      if (_exerciseRepository.hasCachedData) {
        debugPrint(
          '🏠 [HOME_CONTROLLER] refreshData() - Falling back to cache',
        );
        final cachedExercises = _exerciseRepository.getCachedExercises();
        exercises.assignAll(cachedExercises);

        _showSnackbar(
          'Actualización Fallida',
          'Usando datos guardados localmente',
          isError: false,
        );
      } else {
        error.value = e.toString();
        _showSnackbar(
          'Error de Actualización',
          'No se pudieron actualizar los datos: ${e.toString()}',
          isError: true,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasError => error.value.isNotEmpty;
  bool get hasExercises => exercises.isNotEmpty;

  /// Test connectivity detection (for debugging)
  Future<void> testConnectivity() async {
    debugPrint('🧪 [CONNECTIVITY] Testing connectivity...');
    try {
      final result = await Connectivity().checkConnectivity();
      debugPrint('🧪 [CONNECTIVITY] Test result: $result');
      _handleConnectivityChange(result);
    } catch (e) {
      debugPrint('❌ [CONNECTIVITY] Test error: $e');
    }
  }

  /// Initialize connectivity monitoring
  void _initializeConnectivity() {
    debugPrint('🌐 [CONNECTIVITY] Initializing connectivity monitoring...');

    // Check initial connectivity status
    _checkConnectivityStatus();

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) {
        debugPrint('🌐 [CONNECTIVITY] Connectivity changed to: $result');
        _handleConnectivityChange(result);
      },
      onError: (error) {
        debugPrint('❌ [CONNECTIVITY] Error listening to changes: $error');
      },
    );

    debugPrint('✅ [CONNECTIVITY] Connectivity monitoring initialized');
  }

  /// Check current connectivity status
  Future<void> _checkConnectivityStatus() async {
    try {
      final result = await Connectivity().checkConnectivity();
      debugPrint('🌐 [CONNECTIVITY] Current status: $result');
      _handleConnectivityChange(result);
    } catch (e) {
      debugPrint('❌ [CONNECTIVITY] Error checking status: $e');
    }
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(ConnectivityResult result) {
    final wasOnline = isOnline.value;
    final isNowOnline = result != ConnectivityResult.none;

    debugPrint(
      '🌐 [CONNECTIVITY] Was online: $wasOnline, Is now online: $isNowOnline',
    );

    // Update current status
    isOnline.value = isNowOnline;

    if (wasOnline && !isNowOnline) {
      // Going offline
      debugPrint('🔴 [CONNECTIVITY] Going offline...');
      wasOffline.value = true;
      _showConnectivityBanner(isOnline: false);
    } else if (!wasOnline && isNowOnline) {
      // Coming back online
      debugPrint('🟢 [CONNECTIVITY] Coming back online...');
      wasOffline.value = false;
      _showConnectivityBanner(isOnline: true);

      // Auto-refresh if we were offline
      if (wasOffline.value) {
        Future.delayed(const Duration(seconds: 1), () {
          refreshData();
        });
      }
    }
  }

  /// Show connectivity banner
  void _showConnectivityBanner({required bool isOnline}) {
    debugPrint(
      '🎨 [BANNER] Showing connectivity banner: ${isOnline ? "Online" : "Offline"}',
    );

    // Update banner state
    isConnectivityBannerOnline.value = isOnline;
    isConnectivityBannerVisible.value = true;

    // Auto-hide online banner after 3 seconds
    if (isOnline) {
      Future.delayed(const Duration(seconds: 3), () {
        if (isConnectivityBannerVisible.value &&
            isConnectivityBannerOnline.value) {
          _hideConnectivityBanner();
        }
      });
    }
  }

  /// Hide connectivity banner
  void _hideConnectivityBanner() {
    debugPrint('🎨 [BANNER] Hiding connectivity banner');
    isConnectivityBannerVisible.value = false;
  }

  /// Dismiss connectivity banner manually
  void dismissConnectivityBanner() {
    _hideConnectivityBanner();
  }

  /// Helper method to show snackbars safely
  void _showSnackbar(String title, String message, {required bool isError}) {
    // Use addPostFrameCallback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError
            ? Get.theme.colorScheme.primary
            : Get.theme.colorScheme.primary,
        colorText: isError
            ? Get.theme.colorScheme.onPrimary
            : Get.theme.colorScheme.onPrimary,
        duration: Duration(seconds: isError ? 4 : 2),
      );
    });
  }
}
