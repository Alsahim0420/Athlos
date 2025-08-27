import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_datasource.dart';
import '../models/exercise_model.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;
  final Box<ExerciseModel> _box;

  ExerciseRepositoryImpl({
    required this.remoteDataSource,
    required Box<ExerciseModel> box,
  }) : _box = box;

  @override
  Future<List<ExerciseEntity>> fetchExercises({
    bool forceRefresh = false,
  }) async {
    debugPrint(
      '🏠 [REPOSITORY] fetchExercises() called with forceRefresh: $forceRefresh',
    );
    try {
      if (forceRefresh) {
        debugPrint(
          '🏠 [REPOSITORY] Force refresh mode - calling remote data source',
        );
        // Force refresh: try network and update cache
        final exercises = await remoteDataSource.getExercises();
        debugPrint(
          '🏠 [REPOSITORY] Got ${exercises.length} exercises from remote, saving to cache',
        );
        await _saveExercisesToCache(exercises);
        return exercises;
      }

      // Try network first
      try {
        debugPrint('🏠 [REPOSITORY] Trying network first...');
        final exercises = await remoteDataSource.getExercises();
        debugPrint(
          '🏠 [REPOSITORY] Network successful, got ${exercises.length} exercises',
        );

        if (_box.isEmpty) {
          debugPrint('🏠 [REPOSITORY] Cache is empty, saving first time data');
          // First time: save to cache and return
          await _saveExercisesToCache(exercises);
          return exercises;
        } else {
          debugPrint('🏠 [REPOSITORY] Cache has data, updating with new data');
          // Update cache and return
          await _saveExercisesToCache(exercises);
          return exercises;
        }
      } catch (e) {
        debugPrint('🏠 [REPOSITORY] Network failed: $e, trying cache');
        // Network failed, try to load from cache
        if (_box.isNotEmpty) {
          final cachedExercises = _box.values.toList();
          debugPrint(
            '🏠 [REPOSITORY] Cache has ${cachedExercises.length} exercises, returning cached data',
          );
          return cachedExercises;
        } else {
          debugPrint('🏠 [REPOSITORY] No cache and no network, throwing error');
          // No cache and no network
          throw Exception('Sin conexión y sin datos en caché');
        }
      }
    } catch (e) {
      debugPrint('🏠 [REPOSITORY] Error in fetchExercises: $e');
      rethrow;
    }
  }

  Future<void> _saveExercisesToCache(List<ExerciseModel> exercises) async {
    // Clear existing data and save new data
    await _box.clear();

    // Save exercises by ID to avoid duplicates
    for (final exercise in exercises) {
      await _box.put(exercise.id, exercise);
    }
  }

  @override
  List<ExerciseEntity> getCachedExercises() {
    return _box.values.toList();
  }

  @override
  bool get hasCachedData => _box.isNotEmpty;
}
