import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_routine.dart';
import '../models/training_stage.dart';
import '../services/app_state.dart';
import 'create_routine_screen.dart';
import 'training_stage_screen.dart';

class RoutineDetailScreen extends StatelessWidget {
  final WorkoutRoutine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateRoutineScreen(routine: routine),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Routine'),
                  content: const Text('Are you sure you want to delete this routine?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                await Provider.of<AppState>(context, listen: false)
                    .deleteRoutine(routine.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
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
                  const Text(
                    'Exercises',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...routine.exercises.map((exercise) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Type: ${exercise.type}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...exercise.sets.asMap().entries.map((entry) {
                          final setNum = entry.key + 1;
                          final set = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 4),
                            child: Text(
                              'Set $setNum: ${set.weight} kg × ${set.repetitions} reps',
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }),
                        const Divider(height: 24),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                        'Training History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainingStageScreen(
                                routine: routine,
                              ),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      final stages = appState.getStagesForRoutine(routine.id);
                      if (stages.isEmpty) {
                        return const Text(
                          'No training history yet',
                          style: TextStyle(color: Colors.grey),
                        );
                      }
                      final recentStages = stages.take(3).toList();
                      return Column(
                        children: recentStages.map((stage) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Week ${stage.weekNumber}'),
                            subtitle: Text(
                              '${stage.date.day}/${stage.date.month}/${stage.date.year}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainingStageScreen(routine: routine),
            ),
          );
        },
        label: const Text('Start Training'),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}
