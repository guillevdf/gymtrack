class ExerciseSet {
  final double weight;
  final int repetitions;

  ExerciseSet({
    required this.weight,
    required this.repetitions,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'repetitions': repetitions,
    };
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      weight: (json['weight'] as num).toDouble(),
      repetitions: json['repetitions'] as int,
    );
  }
}
