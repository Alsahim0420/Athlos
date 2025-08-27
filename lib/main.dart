import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/services/http_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/services/theme_service.dart';
import 'features/auth/data/services/session_service.dart';
import 'core/controllers/theme_controller.dart';
import 'package:hive/hive.dart';
import 'features/home/data/models/exercise_model.dart';
import 'features/auth/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🔥 [FIREBASE] Initializing Firebase...');
    // Initialize Firebase with generated options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('🔥 [FIREBASE] Firebase initialized successfully!');
    debugPrint(
      '🔥 [FIREBASE] Current platform: ${DefaultFirebaseOptions.currentPlatform.runtimeType}',
    );
  } catch (e) {
    debugPrint('❌ [FIREBASE] Failed to initialize Firebase: $e');
    rethrow;
  }

  try {
    debugPrint('🔧 [REMOTE_CONFIG] Initializing Remote Config...');
    // Initialize Remote Config
    await RemoteConfigService().initialize();
    debugPrint('✅ [REMOTE_CONFIG] Remote Config initialized successfully!');
  } catch (e) {
    debugPrint('❌ [REMOTE_CONFIG] Failed to initialize Remote Config: $e');
    // Don't rethrow, continue with default values
  }

  try {
    debugPrint('📦 [HIVE] Initializing Hive...');

    // Register Hive adapters
    debugPrint('🔧 [HIVE] Registering ExerciseModel adapter...');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ExerciseModelAdapter());
      debugPrint('✅ [HIVE] ExerciseModel adapter registered successfully');
    } else {
      debugPrint('✅ [HIVE] ExerciseModel adapter already registered');
    }

    debugPrint('🔧 [HIVE] Registering UserModel adapter...');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserModelAdapter());
      debugPrint('✅ [HIVE] UserModel adapter registered successfully');
    } else {
      debugPrint('✅ [HIVE] UserModel adapter already registered');
    }

    // Initialize Hive
    await SessionService.init();

    // Open exercises box
    debugPrint('📦 [HIVE] Opening exercises box...');
    await Hive.openBox<ExerciseModel>('exercises');
    debugPrint('📦 [HIVE] Exercises box opened successfully!');

    debugPrint('📦 [HIVE] Hive initialized successfully!');
  } catch (e) {
    debugPrint('❌ [HIVE] Failed to initialize Hive: $e');
    rethrow;
  }

  try {
    debugPrint('🌐 [HTTP] Initializing HTTP Service...');
    // Initialize HTTP Service
    Get.put(HttpService());
    debugPrint('🌐 [HTTP] HTTP Service initialized successfully!');
  } catch (e) {
    debugPrint('❌ [HTTP] Failed to initialize HTTP Service: $e');
    rethrow;
  }

  try {
    debugPrint('🎨 [THEME] Initializing Theme Controller...');
    // Initialize Theme Controller
    Get.put(ThemeController());
    debugPrint('🎨 [THEME] Theme Controller initialized successfully!');
  } catch (e) {
    debugPrint('❌ [THEME] Failed to initialize Theme Controller: $e');
    rethrow;
  }

  try {
    debugPrint('🎨 [THEME] Initializing Theme Service...');
    // Initialize Theme Service for persistence
    final themeService = ThemeService();
    debugPrint('🎨 [THEME] ThemeService instance created');
    Get.put(themeService);
    debugPrint('🎨 [THEME] Theme Service put in GetX successfully!');

    // Force load and apply theme before app starts
    debugPrint('🎨 [THEME] Loading saved theme...');
    await themeService.loadTheme();
    debugPrint('🎨 [THEME] Theme loaded and applied before app start');
  } catch (e) {
    debugPrint('❌ [THEME] Failed to initialize Theme Service: $e');
    rethrow;
  }

  debugPrint('🚀 [APP] All services initialized! Starting app...');

  // Check if user is already logged in
  final sessionService = SessionService();
  final isLoggedIn = sessionService.isLoggedIn;
  final initialRoute = isLoggedIn ? AppRoutes.home : AppRoutes.splash;

  debugPrint('🔐 [SESSION] User logged in: $isLoggedIn');
  debugPrint('🔐 [SESSION] Initial route: $initialRoute');

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ATHLOS',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
