import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_routine.dart';
import '../models/training_stage.dart';
import '../services/app_state.dart';

class TrainingStageScreen extends StatefulWidget {
  final WorkoutRoutine routine;

  const TrainingStageScreen({super.key, required this.routine});

  @override
  State<TrainingStageScreen> createState() => _TrainingStageScreenState();
}

class _TrainingStageScreenState extends State<TrainingStageScreen> {
  final Map<String, Map<int, TextEditingController>> _weightControllers = {};
  int _currentWeek = 1;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadLatestWeek();
  }

  void _initializeControllers() {
    for (var exercise in widget.routine.exercises) {
      _weightControllers[exercise.id] = {};
      for (var i = 0; i < exercise.sets.length; i++) {
        _weightControllers[exercise.id]![i] = TextEditingController(
          text: exercise.sets[i].weight.toString(),
        );
      }
    }
  }

  void _loadLatestWeek() {
    final appState = Provider.of<AppState>(context, listen: false);
    final stages = appState.getStagesForRoutine(widget.routine.id);
    if (stages.isNotEmpty) {
      setState(() {
        _currentWeek = stages.first.weekNumber + 1;
      });
    }
  }

  @override
  void dispose() {
    for (var exerciseControllers in _weightControllers.values) {
      for (var controller in exerciseControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _saveTrainingStage() async {
    final exerciseWeights = <String, Map<int, double>>{};
    bool hasInvalidWeight = false;
    
    for (var entry in _weightControllers.entries) {
      final exerciseId = entry.key;
      final setWeights = <int, double>{};
      
      for (var setEntry in entry.value.entries) {
        final weight = double.tryParse(setEntry.value.text);
        if (weight == null) {
          hasInvalidWeight = true;
          break;
        }
        setWeights[setEntry.key] = weight;
      }
      
      if (hasInvalidWeight) break;
      exerciseWeights[exerciseId] = setWeights;
    }
    
    if (hasInvalidWeight) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid weights for all sets')),
        );
      }
      return;
    }

    final stage = TrainingStage(
      id: const Uuid().v4(),
      routineId: widget.routine.id,
      weekNumber: _currentWeek,
      date: DateTime.now(),
      exerciseWeights: exerciseWeights,
    );

    final appState = Provider.of<AppState>(context, listen: false);
    await appState.addStage(stage);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Training stage saved!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.routine.name} - Week $_currentWeek'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTrainingStage,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Week Number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: _currentWeek > 1
                                ? () {
                                    setState(() {
                                      _currentWeek--;
                                    });
                                  }
                                : null,
                          ),
                          Text(
                            '$_currentWeek',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _currentWeek++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Progressive Overload Tracking',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Update the weights for each set to track your progress',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...widget.routine.exercises.map((exercise) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Type: ${exercise.type}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...exercise.sets.asMap().entries.map((entry) {
                      final setNum = entry.key + 1;
                      final set = entry.value;
                      final controller = _weightControllers[exercise.id]![entry.key]!;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                'Set $setNum',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'Weight (kg)',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 80,
                              child: Text(
                                '× ${set.repetitions} reps',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveTrainingStage,
        label: const Text('Save Progress'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
