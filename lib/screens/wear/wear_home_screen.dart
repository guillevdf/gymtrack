import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/workout_routine.dart';

class WearHomeScreen extends StatelessWidget {
  const WearHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, appState, child) {
            if (appState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (appState.routines.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fitness_center, size: 40),
                    SizedBox(height: 12),
                    Text(
                      'No routines',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: appState.routines.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final routine = appState.routines[index];
                return _WearRoutineCard(routine: routine);
              },
            );
          },
        ),
      ),
    );
  }
}

class _WearRoutineCard extends StatelessWidget {
  final WorkoutRoutine routine;

  const _WearRoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(
          routine.name,
          style: const TextStyle(fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${routine.exercises.length} ex.',
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WearRoutineDetailScreen(routine: routine),
            ),
          );
        },
      ),
    );
  }
}

class WearRoutineDetailScreen extends StatelessWidget {
  final WorkoutRoutine routine;

  const WearRoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          routine.name,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: ListView.builder(
        itemCount: routine.exercises.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final exercise = routine.exercises[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.type,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ...exercise.sets.asMap().entries.map((entry) {
                    final setNum = entry.key + 1;
                    final set = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        'Set $setNum: ${set.weight}kg × ${set.repetitions}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
