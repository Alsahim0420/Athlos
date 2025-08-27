import '../entities/exercise_entity.dart';

abstract class ExerciseRepository {
  Future<List<ExerciseEntity>> fetchExercises({bool forceRefresh = false});
  List<ExerciseEntity> getCachedExercises();
  bool get hasCachedData;
}
