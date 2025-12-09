import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_routine.dart';
import '../models/exercise.dart';
import '../models/exercise_set.dart';
import '../services/app_state.dart';
import 'package:uuid/uuid.dart';

class CreateRoutineScreen extends StatefulWidget {
  final WorkoutRoutine? routine;

  const CreateRoutineScreen({super.key, this.routine});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<ExerciseBuilder> _exercises = [];

  @override
  void initState() {
    super.initState();
    if (widget.routine != null) {
      _nameController.text = widget.routine!.name;
      for (var exercise in widget.routine!.exercises) {
        _exercises.add(ExerciseBuilder.fromExercise(exercise));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addExercise() {
    setState(() {
      _exercises.add(ExerciseBuilder());
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate() && _exercises.isNotEmpty) {
      final exercises = _exercises.map((e) => e.toExercise()).toList();
      final routine = WorkoutRoutine(
        id: widget.routine?.id ?? const Uuid().v4(),
        name: _nameController.text,
        exercises: exercises,
        createdAt: widget.routine?.createdAt ?? DateTime.now(),
      );

      final appState = Provider.of<AppState>(context, listen: false);
      if (widget.routine != null) {
        await appState.updateRoutine(widget.routine!.id, routine);
      } else {
        await appState.addRoutine(routine);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } else if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine != null ? 'Edit Routine' : 'Create Routine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRoutine,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Routine Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a routine name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exercises',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addExercise,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exercise'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._exercises.asMap().entries.map((entry) {
              return _ExerciseCard(
                key: ValueKey(entry.key),
                exercise: entry.value,
                onRemove: () => _removeExercise(entry.key),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ExerciseBuilder {
  final TextEditingController nameController;
  final TextEditingController typeController;
  final List<SetBuilder> sets;
  String? id;

  ExerciseBuilder({this.id})
      : nameController = TextEditingController(),
        typeController = TextEditingController(),
        sets = [SetBuilder()];

  ExerciseBuilder.fromExercise(Exercise exercise)
      : nameController = TextEditingController(text: exercise.name),
        typeController = TextEditingController(text: exercise.type),
        sets = exercise.sets.map((s) => SetBuilder.fromSet(s)).toList(),
        id = exercise.id;

  void addSet() {
    sets.add(SetBuilder());
  }

  void removeSet(int index) {
    if (sets.length > 1) {
      sets.removeAt(index);
    }
  }

  Exercise toExercise() {
    return Exercise(
      id: id ?? const Uuid().v4(),
      name: nameController.text,
      type: typeController.text,
      sets: sets.map((s) => s.toSet()).toList(),
    );
  }

  void dispose() {
    nameController.dispose();
    typeController.dispose();
    for (var set in sets) {
      set.dispose();
    }
  }
}

class SetBuilder {
  final TextEditingController weightController;
  final TextEditingController repsController;

  SetBuilder()
      : weightController = TextEditingController(),
        repsController = TextEditingController();

  SetBuilder.fromSet(ExerciseSet set)
      : weightController = TextEditingController(text: set.weight.toString()),
        repsController = TextEditingController(text: set.repetitions.toString());

  ExerciseSet toSet() {
    // Validation is handled by TextFormField validators before this is called
    // Fallback to 0 should never happen in normal usage
    return ExerciseSet(
      weight: double.tryParse(weightController.text) ?? 0,
      repetitions: int.tryParse(repsController.text) ?? 0,
    );
  }

  void dispose() {
    weightController.dispose();
    repsController.dispose();
  }
}

class _ExerciseCard extends StatefulWidget {
  final ExerciseBuilder exercise;
  final VoidCallback onRemove;

  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.onRemove,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.exercise.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Exercise Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: widget.exercise.typeController,
              decoration: const InputDecoration(
                labelText: 'Exercise Type',
                border: OutlineInputBorder(),
                hintText: 'e.g., Compound, Isolation',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sets',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      widget.exercise.addSet();
                    });
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Set'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...widget.exercise.sets.asMap().entries.map((entry) {
              return _SetRow(
                key: ValueKey(entry.key),
                setBuilder: entry.value,
                setNumber: entry.key + 1,
                onRemove: widget.exercise.sets.length > 1
                    ? () {
                        setState(() {
                          widget.exercise.removeSet(entry.key);
                        });
                      }
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final SetBuilder setBuilder;
  final int setNumber;
  final VoidCallback? onRemove;

  const _SetRow({
    super.key,
    required this.setBuilder,
    required this.setNumber,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              'Set $setNumber',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: setBuilder.weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (double.tryParse(value) == null) {
                  return 'Invalid';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: setBuilder.repsController,
              decoration: const InputDecoration(
                labelText: 'Reps',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (int.tryParse(value) == null) {
                  return 'Invalid';
                }
                return null;
              },
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: onRemove,
              padding: const EdgeInsets.all(8),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
