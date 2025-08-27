import '../../domain/entities/exercise_filters.dart';

class ExerciseFiltersModel extends ExerciseFilters {
  const ExerciseFiltersModel({
    super.category,
    super.targetMuscle,
    super.equipment,
    super.difficulty,
    super.bodyPart,
  });

  @override
  ExerciseFiltersModel copyWith({
    String? category,
    String? targetMuscle,
    String? equipment,
    String? difficulty,
    String? bodyPart,
  }) {
    return ExerciseFiltersModel(
      category: category ?? this.category,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      bodyPart: bodyPart ?? this.bodyPart,
    );
  }

  @override
  Map<String, String?> toMap() {
    return {
      'category': category,
      'targetMuscle': targetMuscle,
      'equipment': equipment,
      'difficulty': difficulty,
      'bodyPart': bodyPart,
    };
  }

  @override
  String toString() {
    final filters = <String>[];
    if (category != null) filters.add('Categoría: $category');
    if (targetMuscle != null) filters.add('Músculo: $targetMuscle');
    if (equipment != null) filters.add('Equipamiento: $equipment');
    if (difficulty != null) filters.add('Dificultad: $difficulty');
    if (bodyPart != null) filters.add('Parte del cuerpo: $bodyPart');

    return filters.isEmpty ? 'Sin filtros' : filters.join(', ');
  }

  // Factory constructor for empty filters
  factory ExerciseFiltersModel.empty() => const ExerciseFiltersModel();

  // Factory constructor from map
  factory ExerciseFiltersModel.fromMap(Map<String, dynamic> map) {
    return ExerciseFiltersModel(
      category: map['category'],
      targetMuscle: map['targetMuscle'],
      equipment: map['equipment'],
      difficulty: map['difficulty'],
      bodyPart: map['bodyPart'],
    );
  }
}
