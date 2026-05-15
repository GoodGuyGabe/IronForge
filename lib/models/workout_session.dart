import 'exercise.dart';
import 'workout_set.dart';

class WorkoutSession {
  final DateTime date;
  final List<Exercise> exercises;
  final bool isKg;

  const WorkoutSession({
    required this.date,
    required this.exercises,
    required this.isKg,
  });

  int get totalExercises => exercises.length;

  int get totalSets =>
      exercises.fold(0, (sum, exercise) => sum + exercise.sets.length);

  WorkoutSession copy() {
    return WorkoutSession(
      date: date,
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
  }
}