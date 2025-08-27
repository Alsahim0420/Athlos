import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../../../auth/data/services/session_service.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../data/models/user_profile_model.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<UserProfileEntity?> userProfile = Rx<UserProfileEntity?>(null);

  @override
  void onInit() {
    super.onInit();
    // Wait a bit for Hive to be fully initialized after hot restart
    Future.delayed(const Duration(milliseconds: 500), () {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      debugPrint('👤 [PROFILE] Loading user profile from local storage...');
      isLoading.value = true;
      error.value = '';

      // Ensure Hive is ready
      await _ensureHiveReady();

      // Get user data ONLY from Hive session (local storage)
      final sessionService = SessionService();
      final cachedUser = sessionService.userData;

      if (cachedUser != null) {
        debugPrint('👤 [PROFILE] User data found in local storage');
        final profile = UserProfileModel.fromUserModel(cachedUser);
        userProfile.value = profile;
        debugPrint(
          '👤 [PROFILE] Profile loaded from local storage: ${profile.fullName}',
        );
      } else {
        // No user data in local storage
        debugPrint('👤 [PROFILE] No user data found in local storage');
        error.value = 'No hay datos de usuario en el almacenamiento local';

        // Show snackbar after build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Error',
            'No se encontraron datos de usuario. Por favor, inicia sesión nuevamente.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            duration: const Duration(seconds: 4),
          );
        });
      }
    } catch (e) {
      debugPrint('👤 [PROFILE] Error loading profile: $e');
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'No se pudo cargar el perfil: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Ensure Hive is ready before accessing data
  Future<void> _ensureHiveReady() async {
    try {
      debugPrint('🔧 [PROFILE] Ensuring Hive is ready...');

      // Check if Hive is initialized
      if (!Hive.isBoxOpen('session')) {
        debugPrint('🔧 [PROFILE] Session box not open, waiting for Hive...');
        // Wait a bit more for Hive to be ready
        await Future.delayed(const Duration(milliseconds: 300));

        // Try to open the box if it's not open
        if (!Hive.isBoxOpen('session')) {
          debugPrint('🔧 [PROFILE] Still waiting for Hive to be ready...');
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      debugPrint('✅ [PROFILE] Hive is ready');
    } catch (e) {
      debugPrint('⚠️ [PROFILE] Warning: Could not ensure Hive readiness: $e');
    }
  }

  Future<void> logout() async {
    try {
      debugPrint('👤 [PROFILE] Logging out...');

      // Clear Hive session
      final sessionService = SessionService();
      await sessionService.clearLoginSession();
      debugPrint('👤 [PROFILE] Hive session cleared');

      // Sign out from Firebase
      await _auth.signOut();
      debugPrint('👤 [PROFILE] Firebase Auth signed out');

      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint('👤 [PROFILE] Error during logout: $e');
      Get.snackbar(
        'Error',
        'Error al cerrar sesión: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
      );
    }
  }

  bool get hasError => error.value.isNotEmpty;
  bool get hasProfile => userProfile.value != null;

  // Public method to reload profile
  Future<void> reloadProfile() async {
    await _loadUserProfile();
  }
}
