import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_session.dart';
import '../models/workout_set.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Exercise> exercises = [
    const Exercise(
      name: 'Bench Press',
      sets: [
        WorkoutSet(reps: 8, weight: 135),
        WorkoutSet(reps: 6, weight: 155),
      ],
    ),
    const Exercise(
      name: 'Barbell Squat',
      sets: [
        WorkoutSet(reps: 8, weight: 185),
        WorkoutSet(reps: 5, weight: 205),
      ],
    ),
    const Exercise(
      name: 'Lat Pulldown',
      sets: [
        WorkoutSet(reps: 12, weight: 120),
        WorkoutSet(reps: 10, weight: 130),
      ],
    ),
  ];

  final List<WorkoutSession> sessions = [];

  bool isKg = false;

  int get totalExercises => exercises.length;

  int get totalSets =>
      exercises.fold(0, (sum, exercise) => sum + exercise.sets.length);

  void _showAddExerciseSheet() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Exercise',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Exercise name',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _addExercise(controller.text),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addExercise(controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Add Exercise',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addExercise(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return;
    }

    setState(() {
      exercises.add(
        Exercise(
          name: trimmedName,
          sets: const [],
        ),
      );
    });

    Navigator.of(context).pop();
  }

  void _showAddSetSheet(int exerciseIndex) {
    final weightController = TextEditingController();
    final repsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final exercise = exercises[exerciseIndex];
        final unitLabel = isKg ? 'kg' : 'lbs';

        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Set - ${exercise.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Weight ($unitLabel)',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Reps',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _addSet(
                  exerciseIndex,
                  weightController.text,
                  repsController.text,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addSet(
                    exerciseIndex,
                    weightController.text,
                    repsController.text,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Add Set',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addSet(
    int exerciseIndex,
    String weightText,
    String repsText,
  ) {
    final enteredWeight = double.tryParse(weightText.trim());
    final reps = int.tryParse(repsText.trim());

    if (enteredWeight == null || reps == null || reps <= 0 || enteredWeight < 0) {
      return;
    }

    final storedWeightInLbs = isKg ? enteredWeight / 0.453592 : enteredWeight;

    setState(() {
      final currentExercise = exercises[exerciseIndex];
      final updatedSets = List<WorkoutSet>.from(currentExercise.sets)
        ..add(
          WorkoutSet(
            reps: reps,
            weight: storedWeightInLbs,
          ),
        );

      exercises[exerciseIndex] = Exercise(
        name: currentExercise.name,
        sets: updatedSets,
      );
    });

    Navigator.of(context).pop();
  }

  Future<void> _confirmDeleteExercise(int exerciseIndex) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Delete Exercise',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Delete ${exercises[exerciseIndex].name}?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        exercises.removeAt(exerciseIndex);
      });
    }
  }

  Future<void> _confirmDeleteSet(int exerciseIndex, int setIndex) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Delete Set',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Delete this set?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        final currentExercise = exercises[exerciseIndex];
        final updatedSets = List<WorkoutSet>.from(currentExercise.sets)
          ..removeAt(setIndex);

        exercises[exerciseIndex] = Exercise(
          name: currentExercise.name,
          sets: updatedSets,
        );
      });
    }
  }

  void _deleteSession(int index) {
    setState(() {
      sessions.removeAt(index);
    });
  }

  Future<void> _finishWorkout() async {
    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one exercise before saving a session.'),
        ),
      );
      return;
    }

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Finish Workout',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Save this workout to history and clear the current session?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xFFFF8C42)),
              ),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      final session = WorkoutSession(
  date: DateTime.now(),
  isKg: isKg,
  exercises: exercises
      .map(
        (exercise) => Exercise(
          name: exercise.name,
          sets: exercise.sets
              .map(
                (set) => WorkoutSet(
                  reps: set.reps,
                  weight: set.weight,
                ),
              )
              .toList(),
        ),
      )
      .toList(),
);

      setState(() {
        sessions.insert(0, session.copy());
        exercises.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout saved to history 💪'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoryScreen(
          sessions: sessions,
          onDeleteSession: _deleteSession,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF121212);
    const cardColor = Color(0xFF1E1E1E);
    const accentColor = Color(0xFFFF8C42);
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFFB0B0B0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openHistory,
            icon: const Icon(Icons.history),
            color: Colors.white,
            tooltip: 'History',
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.hardware,
              color: Color(0xFFB0B0B0),
              size: 24,
            ),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Iron',
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Forge',
                    style: TextStyle(
                      color: Color(0xFFFF8C42),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExerciseSheet,
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Workout",
              style: TextStyle(
                color: textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Track your lifts and build consistency.',
              style: TextStyle(
                color: textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Exercises',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$totalExercises',
                          style: const TextStyle(
                            color: textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sets Logged',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$totalSets',
                          style: const TextStyle(
                            color: textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'lbs',
                  style: TextStyle(color: Colors.white70),
                ),
                Switch(
                  value: isKg,
                  activeColor: accentColor,
                  onChanged: (value) {
                    setState(() {
                      isKg = value;
                    });
                  },
                ),
                const Text(
                  'kg',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _finishWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Finish Workout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: exercises.isEmpty
                  ? const Center(
                      child: Text(
                        'No exercises in this session yet.',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: exercises.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];

                        return GestureDetector(
                          onTap: () => _showAddSetSheet(index),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          color: textPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _confirmDeleteExercise(index),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      ),
                                      tooltip: 'Delete exercise',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tap card to add a set',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                if (exercise.sets.isEmpty)
                                  const Text(
                                    'No sets added yet.',
                                    style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 15,
                                    ),
                                  )
                                else
                                  ...exercise.sets.asMap().entries.map((entry) {
                                    final setIndex = entry.key;
                                    final set = entry.value;

                                    final displayWeight =
                                        isKg ? set.weight * 0.453592 : set.weight;
                                    final unit = isKg ? 'kg' : 'lbs';

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              color: const Color(0x33FF8C42),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${setIndex + 1}',
                                                style: const TextStyle(
                                                  color: accentColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Text(
                                              '${displayWeight.toStringAsFixed(displayWeight % 1 == 0 ? 0 : 1)} $unit × ${set.reps}',
                                              style: const TextStyle(
                                                color: textPrimary,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _confirmDeleteSet(
                                              index,
                                              setIndex,
                                            ),
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 20,
                                            ),
                                            tooltip: 'Delete set',
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}