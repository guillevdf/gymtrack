class TrainingStage {
  final String id;
  final String routineId;
  final int weekNumber;
  final DateTime date;
  final Map<String, Map<int, double>> exerciseWeights;

  TrainingStage({
    required this.id,
    required this.routineId,
    required this.weekNumber,
    required this.date,
    required this.exerciseWeights,
  });

  Map<String, dynamic> toJson() {
    final weightsJson = <String, dynamic>{};
    exerciseWeights.forEach((exerciseId, setWeights) {
      weightsJson[exerciseId] = setWeights.map(
        (setIndex, weight) => MapEntry(setIndex.toString(), weight),
      );
    });

    return {
      'id': id,
      'routineId': routineId,
      'weekNumber': weekNumber,
      'date': date.toIso8601String(),
      'exerciseWeights': weightsJson,
    };
  }

  factory TrainingStage.fromJson(Map<String, dynamic> json) {
    final weightsJson = json['exerciseWeights'] as Map<String, dynamic>;
    final exerciseWeights = <String, Map<int, double>>{};
    
    weightsJson.forEach((exerciseId, setWeights) {
      final weights = <int, double>{};
      (setWeights as Map<String, dynamic>).forEach((setIndexStr, weight) {
        weights[int.parse(setIndexStr)] = (weight as num).toDouble();
      });
      exerciseWeights[exerciseId] = weights;
    });

    return TrainingStage(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      weekNumber: json['weekNumber'] as int,
      date: DateTime.parse(json['date'] as String),
      exerciseWeights: exerciseWeights,
    );
  }
}
