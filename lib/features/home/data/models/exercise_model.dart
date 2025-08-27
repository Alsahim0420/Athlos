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

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.gifUrl,
  }) : super(
         id: id,
         name: name,
         bodyPart: bodyPart,
         target: target,
         equipment: equipment,
         gifUrl: gifUrl,
       );

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bodyPart: json['bodyPart']?.toString() ?? '',
      target: json['target']?.toString() ?? '',
      equipment: json['equipment']?.toString() ?? '',
      gifUrl: json['gifUrl']?.toString() ?? '',
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
    };
  }

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? bodyPart,
    String? target,
    String? equipment,
    String? gifUrl,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyPart: bodyPart ?? this.bodyPart,
      target: target ?? this.target,
      equipment: equipment ?? this.equipment,
      gifUrl: gifUrl ?? this.gifUrl,
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
