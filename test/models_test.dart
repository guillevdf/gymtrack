import 'package:flutter_test/flutter_test.dart';
import 'package:gymtrack/models/exercise_set.dart';
import 'package:gymtrack/models/exercise.dart';
import 'package:gymtrack/models/workout_routine.dart';
import 'package:gymtrack/models/training_stage.dart';

void main() {
  group('ExerciseSet', () {
    test('should create ExerciseSet with valid data', () {
      final set = ExerciseSet(weight: 100.0, repetitions: 10);
      
      expect(set.weight, 100.0);
      expect(set.repetitions, 10);
    });

    test('should serialize to JSON', () {
      final set = ExerciseSet(weight: 100.0, repetitions: 10);
      final json = set.toJson();
      
      expect(json['weight'], 100.0);
      expect(json['repetitions'], 10);
    });

    test('should deserialize from JSON', () {
      final json = {'weight': 100.0, 'repetitions': 10};
      final set = ExerciseSet.fromJson(json);
      
      expect(set.weight, 100.0);
      expect(set.repetitions, 10);
    });
  });

  group('Exercise', () {
    test('should create Exercise with sets', () {
      final sets = [
        ExerciseSet(weight: 100.0, repetitions: 10),
        ExerciseSet(weight: 105.0, repetitions: 8),
      ];
      final exercise = Exercise(
        id: 'ex1',
        name: 'Bench Press',
        type: 'Compound',
        sets: sets,
      );
      
      expect(exercise.id, 'ex1');
      expect(exercise.name, 'Bench Press');
      expect(exercise.type, 'Compound');
      expect(exercise.sets.length, 2);
    });

    test('should serialize to JSON', () {
      final sets = [ExerciseSet(weight: 100.0, repetitions: 10)];
      final exercise = Exercise(
        id: 'ex1',
        name: 'Bench Press',
        type: 'Compound',
        sets: sets,
      );
      final json = exercise.toJson();
      
      expect(json['id'], 'ex1');
      expect(json['name'], 'Bench Press');
      expect(json['type'], 'Compound');
      expect(json['sets'] is List, true);
    });

    test('should copyWith correctly', () {
      final sets = [ExerciseSet(weight: 100.0, repetitions: 10)];
      final exercise = Exercise(
        id: 'ex1',
        name: 'Bench Press',
        type: 'Compound',
        sets: sets,
      );
      final copied = exercise.copyWith(name: 'Incline Bench Press');
      
      expect(copied.name, 'Incline Bench Press');
      expect(copied.id, 'ex1');
      expect(copied.type, 'Compound');
    });
  });

  group('WorkoutRoutine', () {
    test('should create WorkoutRoutine with exercises', () {
      final exercises = [
        Exercise(
          id: 'ex1',
          name: 'Bench Press',
          type: 'Compound',
          sets: [ExerciseSet(weight: 100.0, repetitions: 10)],
        ),
      ];
      final routine = WorkoutRoutine(
        id: 'r1',
        name: 'Push Day',
        exercises: exercises,
        createdAt: DateTime(2024, 1, 1),
      );
      
      expect(routine.name, 'Push Day');
      expect(routine.exercises.length, 1);
    });

    test('should serialize and deserialize correctly', () {
      final exercises = [
        Exercise(
          id: 'ex1',
          name: 'Bench Press',
          type: 'Compound',
          sets: [ExerciseSet(weight: 100.0, repetitions: 10)],
        ),
      ];
      final routine = WorkoutRoutine(
        id: 'r1',
        name: 'Push Day',
        exercises: exercises,
        createdAt: DateTime(2024, 1, 1),
      );
      
      final json = routine.toJson();
      final deserialized = WorkoutRoutine.fromJson(json);
      
      expect(deserialized.id, routine.id);
      expect(deserialized.name, routine.name);
      expect(deserialized.exercises.length, routine.exercises.length);
    });
  });

  group('TrainingStage', () {
    test('should create TrainingStage with exercise weights', () {
      final exerciseWeights = {
        'ex1': {0: 100.0, 1: 105.0},
        'ex2': {0: 80.0, 1: 85.0},
      };
      final stage = TrainingStage(
        id: 's1',
        routineId: 'r1',
        weekNumber: 1,
        date: DateTime(2024, 1, 1),
        exerciseWeights: exerciseWeights,
      );
      
      expect(stage.weekNumber, 1);
      expect(stage.exerciseWeights.length, 2);
      expect(stage.exerciseWeights['ex1']![0], 100.0);
    });

    test('should serialize and deserialize correctly', () {
      final exerciseWeights = {
        'ex1': {0: 100.0, 1: 105.0},
      };
      final stage = TrainingStage(
        id: 's1',
        routineId: 'r1',
        weekNumber: 1,
        date: DateTime(2024, 1, 1),
        exerciseWeights: exerciseWeights,
      );
      
      final json = stage.toJson();
      final deserialized = TrainingStage.fromJson(json);
      
      expect(deserialized.id, stage.id);
      expect(deserialized.routineId, stage.routineId);
      expect(deserialized.weekNumber, stage.weekNumber);
      expect(deserialized.exerciseWeights['ex1']![0], 100.0);
    });
  });
}
