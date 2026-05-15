import 'workout_set.dart';

class Exercise {
  final String name;
  final List<WorkoutSet> sets;

  const Exercise({
    required this.name,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      sets: (json['sets'] as List)
          .map((setJson) => WorkoutSet.fromJson(setJson as Map<String, dynamic>))
          .toList(),
    );
  }
}