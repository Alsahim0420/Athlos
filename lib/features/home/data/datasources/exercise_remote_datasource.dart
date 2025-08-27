import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercises({int limit = 50});
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final http.Client client;

  ExerciseRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ExerciseModel>> getExercises({int limit = 50}) async {
    debugPrint('🏠 [DATASOURCE] getExercises() called with limit: $limit');
    try {
      debugPrint('🏠 [DATASOURCE] Making HTTP request to ExerciseDB...');
      debugPrint(
        '🏠 [DATASOURCE] URL: ${ApiConfig.exerciseDbBaseUrl}/exercises',
      );
      debugPrint('🏠 [DATASOURCE] Headers: ${ApiConfig.exerciseDbHeaders}');

      final response = await client
          .get(
            Uri.parse('${ApiConfig.exerciseDbBaseUrl}/exercises'),
            headers: ApiConfig.exerciseDbHeaders,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('🏠 [DATASOURCE] Response status: ${response.statusCode}');
      debugPrint(
        '🏠 [DATASOURCE] Response body length: ${response.body.length}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        debugPrint(
          '🏠 [DATASOURCE] Parsed ${jsonList.length} exercises from JSON',
        );

        final exercises = jsonList
            .map((json) => ExerciseModel.fromJson(json))
            .take(limit)
            .toList();

        debugPrint(
          '🏠 [DATASOURCE] Returning ${exercises.length} exercises (limited to $limit)',
        );
        return exercises;
      } else {
        debugPrint('🏠 [DATASOURCE] HTTP error: ${response.statusCode}');
        throw HttpException(
          'Failed to load exercises. Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      debugPrint('🏠 [DATASOURCE] SocketException: No internet connection');
      throw const SocketException('No internet connection');
    } on TimeoutException {
      debugPrint('🏠 [DATASOURCE] TimeoutException: Request timeout');
      throw const TimeoutException('Request timeout');
    } on FormatException {
      debugPrint('🏠 [DATASOURCE] FormatException: Invalid response format');
      throw const FormatException('Invalid response format');
    } catch (e) {
      debugPrint('🏠 [DATASOURCE] Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException(this.message);

  @override
  String toString() => message;
}
