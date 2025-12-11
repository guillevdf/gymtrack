import 'exercise_set.dart';

class Exercise {
  final String id;
  final String name;
  final String type;
  final List<ExerciseSet> sets;

  Exercise({
    required this.id,
    required this.name,
    required this.type,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'sets': sets.map((s) => s.toJson()).toList(),
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      sets: (json['sets'] as List)
          .map((s) => ExerciseSet.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? type,
    List<ExerciseSet>? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      sets: sets ?? this.sets,
    );
  }
}
