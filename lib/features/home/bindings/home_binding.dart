import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../data/datasources/exercise_remote_datasource.dart';
import '../data/models/exercise_model.dart';
import '../data/repositories/exercise_repository_impl.dart';
import '../domain/repositories/exercise_repository.dart';
import '../presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() async {
    debugPrint('🏠 [HOME_BINDING] Starting dependencies injection...');

    // Open Hive box for exercises
    if (!Hive.isBoxOpen('exercises')) {
      debugPrint('🏠 [HOME_BINDING] Opening Hive box "exercises"...');
      await Hive.openBox<ExerciseModel>('exercises');
      debugPrint('🏠 [HOME_BINDING] Hive box opened successfully');
    } else {
      debugPrint('🏠 [HOME_BINDING] Hive box "exercises" already open');
    }

    // Register dependencies
    debugPrint('🏠 [HOME_BINDING] Registering HTTP client...');
    Get.lazyPut<http.Client>(() => http.Client());

    debugPrint('🏠 [HOME_BINDING] Registering ExerciseRemoteDataSource...');
    Get.lazyPut<ExerciseRemoteDataSource>(
      () => ExerciseRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    debugPrint('🏠 [HOME_BINDING] Registering ExerciseRepository...');
    Get.lazyPut<ExerciseRepository>(
      () => ExerciseRepositoryImpl(
        remoteDataSource: Get.find<ExerciseRemoteDataSource>(),
        box: Hive.box<ExerciseModel>('exercises'),
      ),
    );

    debugPrint('🏠 [HOME_BINDING] Registering HomeController...');
    Get.lazyPut<HomeController>(
      () => HomeController(exerciseRepository: Get.find<ExerciseRepository>()),
    );

    // Force instantiation of HomeController to trigger onInit
    debugPrint('🏠 [HOME_BINDING] Forcing HomeController instantiation...');
    final controller = Get.find<HomeController>();
    debugPrint(
      '🏠 [HOME_BINDING] HomeController instantiated: ${controller.runtimeType}',
    );

    debugPrint('🏠 [HOME_BINDING] All dependencies registered successfully');
  }
}
