class WorkoutSet {
  final int reps;
  final double weight;

  const WorkoutSet({
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
    );
  }
}