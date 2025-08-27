import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/services/http_service.dart';
import 'features/auth/data/services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🔥 [FIREBASE] Initializing Firebase...');
    // Initialize Firebase with generated options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 [FIREBASE] Firebase initialized successfully!');
    print(
      '🔥 [FIREBASE] Current platform: ${DefaultFirebaseOptions.currentPlatform.runtimeType}',
    );
  } catch (e) {
    print('❌ [FIREBASE] Failed to initialize Firebase: $e');
    rethrow;
  }

  try {
    print('📦 [HIVE] Initializing Hive...');
    // Initialize Hive
    await SessionService.init();
    print('📦 [HIVE] Hive initialized successfully!');
  } catch (e) {
    print('❌ [HIVE] Failed to initialize Hive: $e');
    rethrow;
  }

  try {
    print('🌐 [HTTP] Initializing HTTP Service...');
    // Initialize HTTP Service
    Get.put(HttpService());
    print('🌐 [HTTP] HTTP Service initialized successfully!');
  } catch (e) {
    print('❌ [HTTP] Failed to initialize HTTP Service: $e');
    rethrow;
  }

  print('🚀 [APP] All services initialized! Starting app...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ATHLOS',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
