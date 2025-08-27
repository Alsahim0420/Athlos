// ignore_for_file: overridden_fields

import 'package:hive/hive.dart';
import '../../domain/entities/exercise_entity.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 1)
class ExerciseModel extends ExerciseEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final String bodyPart;

  @override
  @HiveField(3)
  final String target;

  @override
  @HiveField(4)
  final String equipment;

  @override
  @HiveField(5)
  final String gifUrl;

  @override
  @HiveField(6)
  final List<String> secondaryMuscles;

  @override
  @HiveField(7)
  final List<String> instructions;

  @override
  @HiveField(8)
  final String description;

  @override
  @HiveField(9)
  final String difficulty;

  @override
  @HiveField(10)
  final String category;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.gifUrl,
    required this.secondaryMuscles,
    required this.instructions,
    required this.description,
    required this.difficulty,
    required this.category,
  }) : super(
         id: id,
         name: name,
         bodyPart: bodyPart,
         target: target,
         equipment: equipment,
         gifUrl: gifUrl,
         secondaryMuscles: secondaryMuscles,
         instructions: instructions,
         description: description,
         difficulty: difficulty,
         category: category,
       );

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bodyPart: json['bodyPart']?.toString() ?? '',
      target: json['target']?.toString() ?? '',
      equipment: json['equipment']?.toString() ?? '',
      gifUrl: json['gifUrl']?.toString() ?? '',
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      description: json['description']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'target': target,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
      'description': description,
      'difficulty': difficulty,
      'category': category,
    };
  }

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? bodyPart,
    String? target,
    String? equipment,
    String? gifUrl,
    List<String>? secondaryMuscles,
    List<String>? instructions,
    String? description,
    String? difficulty,
    String? category,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyPart: bodyPart ?? this.bodyPart,
      target: target ?? this.target,
      equipment: equipment ?? this.equipment,
      gifUrl: gifUrl ?? this.gifUrl,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      instructions: instructions ?? this.instructions,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
