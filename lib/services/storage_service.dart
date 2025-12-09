import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_routine.dart';
import '../models/training_stage.dart';

class StorageService {
  static const String _routinesKey = 'workout_routines';
  static const String _stagesKey = 'training_stages';

  Future<List<WorkoutRoutine>> loadRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final String? routinesJson = prefs.getString(_routinesKey);
    
    if (routinesJson == null) return [];
    
    final List<dynamic> routinesList = jsonDecode(routinesJson);
    return routinesList
        .map((json) => WorkoutRoutine.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRoutines(List<WorkoutRoutine> routines) async {
    final prefs = await SharedPreferences.getInstance();
    final routinesJson = jsonEncode(routines.map((r) => r.toJson()).toList());
    await prefs.setString(_routinesKey, routinesJson);
  }

  Future<List<TrainingStage>> loadStages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stagesJson = prefs.getString(_stagesKey);
    
    if (stagesJson == null) return [];
    
    final List<dynamic> stagesList = jsonDecode(stagesJson);
    return stagesList
        .map((json) => TrainingStage.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveStages(List<TrainingStage> stages) async {
    final prefs = await SharedPreferences.getInstance();
    final stagesJson = jsonEncode(stages.map((s) => s.toJson()).toList());
    await prefs.setString(_stagesKey, stagesJson);
  }
}
