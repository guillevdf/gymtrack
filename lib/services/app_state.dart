import 'package:flutter/foundation.dart';
import '../models/workout_routine.dart';
import '../models/training_stage.dart';
import 'storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  List<WorkoutRoutine> _routines = [];
  List<TrainingStage> _stages = [];
  bool _isLoading = false;

  List<WorkoutRoutine> get routines => _routines;
  List<TrainingStage> get stages => _stages;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    _routines = await _storageService.loadRoutines();
    _stages = await _storageService.loadStages();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRoutine(WorkoutRoutine routine) async {
    _routines.add(routine);
    await _storageService.saveRoutines(_routines);
    notifyListeners();
  }

  Future<void> updateRoutine(String id, WorkoutRoutine routine) async {
    final index = _routines.indexWhere((r) => r.id == id);
    if (index != -1) {
      _routines[index] = routine;
      await _storageService.saveRoutines(_routines);
      notifyListeners();
    }
  }

  Future<void> deleteRoutine(String id) async {
    _routines.removeWhere((r) => r.id == id);
    await _storageService.saveRoutines(_routines);
    notifyListeners();
  }

  Future<void> addStage(TrainingStage stage) async {
    _stages.add(stage);
    await _storageService.saveStages(_stages);
    notifyListeners();
  }

  List<TrainingStage> getStagesForRoutine(String routineId) {
    return _stages.where((s) => s.routineId == routineId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
