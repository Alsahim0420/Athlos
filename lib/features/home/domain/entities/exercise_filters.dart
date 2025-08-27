abstract class ExerciseFilters {
  final String? category;
  final String? targetMuscle;
  final String? equipment;
  final String? difficulty;
  final String? bodyPart;

  const ExerciseFilters({
    this.category,
    this.targetMuscle,
    this.equipment,
    this.difficulty,
    this.bodyPart,
  });

  bool get hasActiveFilters =>
      category != null ||
      targetMuscle != null ||
      equipment != null ||
      difficulty != null ||
      bodyPart != null;

  ExerciseFilters copyWith({
    String? category,
    String? targetMuscle,
    String? equipment,
    String? difficulty,
    String? bodyPart,
  });

  Map<String, String?> toMap();

  @override
  String toString();
}
