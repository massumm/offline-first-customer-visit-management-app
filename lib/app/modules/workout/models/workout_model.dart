import 'workout_set_data.dart';

class WorkoutModel {
  final String name;
  final String? status;
  final String? exerciseImage;
  final int? order;
  final bool? supportsWeight;
  final bool? supportsReps;
  final bool? supportsDistance;
  final bool? supportsTime;
  final List<String>? equipment;
  final List<String>? muscleGroup;
  final List<WorkoutSetData> sets;
  final int? restTimeSeconds;

  const WorkoutModel({
    required this.name,
    this.status,
    this.exerciseImage,
    this.order,
    this.supportsWeight,
    this.supportsReps,
    this.supportsDistance,
    this.supportsTime,
    this.equipment,
    this.muscleGroup,
    this.restTimeSeconds,
    required this.sets,
  });

  WorkoutModel copyWith({
    String? name,
    String? status,
    String? exerciseImage,
    int? order,
    bool? supportsWeight,
    bool? supportsReps,
    bool? supportsDistance,
    bool? supportsTime,
    List<String>? equipment,
    List<String>? muscleGroup,
    int? restTimeSeconds,
    List<WorkoutSetData>? sets,
  }) {
    return WorkoutModel(
      name: name ?? this.name,
      status: status ?? this.status,
      exerciseImage: exerciseImage ?? this.exerciseImage,
      order: order ?? this.order,
      supportsWeight: supportsWeight ?? this.supportsWeight,
      supportsReps: supportsReps ?? this.supportsReps,
      supportsDistance: supportsDistance ?? this.supportsDistance,
      supportsTime: supportsTime ?? this.supportsTime,
      equipment: equipment ?? this.equipment,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
      sets: sets ?? this.sets,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
    name: json['name'] as String,
    status: json['status'] as String?,
    exerciseImage: json['exerciseImage'] as String?,
    order: json['order'] as int?,
    supportsWeight: json['supportsWeight'] as bool?,
    supportsReps: json['supportsReps'] as bool?,
    supportsDistance: json['supportsDistance'] as bool?,
    supportsTime: json['supportsTime'] as bool?,
    equipment: (json['equipment'] as List<dynamic>?)?.cast<String>(),
    muscleGroup: (json['muscleGroup'] as List<dynamic>?)?.cast<String>(),
    restTimeSeconds: json['restTimeSeconds'] as int?,
    sets:
        (json['sets'] as List<dynamic>?)
            ?.map((e) => WorkoutSetData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'status': status,
    'exerciseImage': exerciseImage,
    'order': order,
    'supportsWeight': supportsWeight,
    'supportsReps': supportsReps,
    'supportsDistance': supportsDistance,
    'supportsTime': supportsTime,
    'equipment': equipment,
    'muscleGroup': muscleGroup,
    'restTimeSeconds': restTimeSeconds,
    'sets': sets.map((set) => set.toJson()).toList(),
  };
}
