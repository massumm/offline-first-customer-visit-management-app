class WorkoutSetData {
  final String setType;
  final String previous;
  final String kg;
  final String reps;
  final bool isComplete;

  WorkoutSetData({
    required this.setType,
    required this.previous,
    required this.kg,
    required this.reps,
    required this.isComplete,
  });

  factory WorkoutSetData.fromJson(Map<String, dynamic> json) {
    return WorkoutSetData(
      setType: json['setType'] ?? '',
      previous: json['previous'] ?? '',
      kg: json['kg'] ?? '',
      reps: json['reps'] ?? '',
      isComplete: json['isComplete'] ?? '',
    );
  }

  WorkoutSetData copyWith({
    String? setType,
    String? previous,
    String? kg,
    String? reps,
    bool? isComplete,
  }) => WorkoutSetData(
    setType: setType ?? this.setType,
    previous: previous ?? this.previous,
    kg: kg ?? this.kg,
    reps: reps ?? this.reps,
    isComplete: isComplete ?? this.isComplete,
  );

  Map<String, dynamic> toJson() => {
    'setType': setType,
    'previous': previous,
    'kg': kg,
    'reps': reps,
    'isComplete': isComplete,
  };
}
