class Workout {
  final int? id;
  final String? user;
  final String? title;
  final String? description;
  final String? status;
  final String? statusDisplay;
  final String? visibility;
  final String? visibilityDisplay;
  final DateTime? startTime;
  final DateTime? endTime;
  final dynamic duration;
  final dynamic durationDisplay;
  final String? totalVolume;
  final int? totalSets;
  final String? image;
  final String? coverImage;
  final List<ExerciseElement>? exercises;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Workout({
    this.id,
    this.user,
    this.title,
    this.description,
    this.status,
    this.statusDisplay,
    this.visibility,
    this.visibilityDisplay,
    this.startTime,
    this.endTime,
    this.duration,
    this.durationDisplay,
    this.totalVolume,
    this.totalSets,
    this.image,
    this.coverImage,
    this.exercises,
    this.createdAt,
    this.updatedAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json["id"],
    user: json["user"],
    title: json["title"],
    description: json["description"],
    status: json["status"],
    statusDisplay: json["status_display"],
    visibility: json["visibility"],
    visibilityDisplay: json["visibility_display"],
    startTime: json["start_time"] == null
        ? null
        : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    duration: json["duration"],
    durationDisplay: json["duration_display"],
    totalVolume: json["total_volume"],
    totalSets: json["total_sets"],
    image: json["image"],
    coverImage: json["cover_image"],
    exercises: json["exercises"] == null
        ? []
        : List<ExerciseElement>.from(
      json["exercises"]!.map((x) => ExerciseElement.fromJson(x)),
    ),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "title": title,
    "description": description,
    "status": status,
    "status_display": statusDisplay,
    "visibility": visibility,
    "visibility_display": visibilityDisplay,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "duration": duration,
    "duration_display": durationDisplay,
    "total_volume": totalVolume,
    "total_sets": totalSets,
    "image": image,
    "cover_image": coverImage,
    "exercises": exercises == null
        ? []
        : List<dynamic>.from(exercises!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ExerciseElement {
  final int? id;
  final int? order;
  final int? restTimeSeconds;
  final ExerciseExercise? exercise;
  final List<Set>? sets;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExerciseElement({
    this.id,
    this.order,
    this.restTimeSeconds,
    this.exercise,
    this.sets,
    this.createdAt,
    this.updatedAt,
  });

  factory ExerciseElement.fromJson(Map<String, dynamic> json) =>
      ExerciseElement(
        id: json["id"],
        order: json["order"],
        restTimeSeconds: json["rest_time_seconds"],
        exercise: json["exercise"] == null
            ? null
            : ExerciseExercise.fromJson(json["exercise"]),
        sets: json["sets"] == null
            ? []
            : List<Set>.from(json["sets"]!.map((x) => Set.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  // Copy With Method
  ExerciseElement copyWith({
    int? id,
    int? order,
    int? restTimeSeconds,
    ExerciseExercise? exercise,
    List<Set>? sets,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExerciseElement(
      id: id ?? this.id,
      order: order ?? this.order,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "order": order,
    "rest_time_seconds": restTimeSeconds,
    "exercise": exercise?.toJson(),
    "sets": sets == null
        ? []
        : List<dynamic>.from(sets!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ExerciseExercise {
  final int? id;
  final String? name;
  final List<String>? equipment;
  final List<String>? muscleGroup;
  final bool? isPopular;
  final String? exerciseImage;
  final bool? supportsWeight;
  final bool? supportsReps;
  final bool? supportsDistance;
  final bool? supportsTime;

  ExerciseExercise({
    this.id,
    this.name,
    this.equipment,
    this.muscleGroup,
    this.isPopular,
    this.exerciseImage,
    this.supportsWeight,
    this.supportsReps,
    this.supportsDistance,
    this.supportsTime,
  });

  factory ExerciseExercise.fromJson(Map<String, dynamic> json) =>
      ExerciseExercise(
        id: json["id"],
        name: json["name"],
        equipment: json["equipment"] == null
            ? []
            : List<String>.from(json["equipment"]!.map((x) => x)),
        muscleGroup: json["muscle_group"] == null
            ? []
            : List<String>.from(json["muscle_group"]!.map((x) => x)),
        isPopular: json["is_popular"],
        exerciseImage: json["exercise_image"],
        supportsWeight: json["supports_weight"],
        supportsReps: json["supports_reps"],
        supportsDistance: json["supports_distance"],
        supportsTime: json["supports_time"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "equipment": equipment == null
        ? []
        : List<dynamic>.from(equipment!.map((x) => x)),
    "muscle_group": muscleGroup == null
        ? []
        : List<dynamic>.from(muscleGroup!.map((x) => x)),
    "is_popular": isPopular,
    "exercise_image": exerciseImage,
    "supports_weight": supportsWeight,
    "supports_reps": supportsReps,
    "supports_distance": supportsDistance,
    "supports_time": supportsTime,
  };
}

class Set {
  final int? id;
  final int? setNumber;
  final String? setType;
  final String? setTypeDisplay;
  final dynamic weightKg;
  final int? reps;
  final dynamic distanceKm;
  final dynamic timeSeconds;
  final bool? isCompleted;
  final dynamic failedAtRep;
  final dynamic previous;
  final dynamic setImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Set({
    this.id,
    this.setNumber,
    this.setType,
    this.setTypeDisplay,
    this.weightKg,
    this.reps,
    this.distanceKm,
    this.timeSeconds,
    this.isCompleted,
    this.failedAtRep,
    this.previous,
    this.setImage,
    this.createdAt,
    this.updatedAt,
  });

  factory Set.fromJson(Map<String, dynamic> json) => Set(
    id: json["id"],
    setNumber: json["set_number"],
    setType: json["set_type"],
    setTypeDisplay: json["set_type_display"],
    weightKg: json["weight_kg"],
    reps: json["reps"],
    distanceKm: json["distance_km"],
    timeSeconds: json["time_seconds"],
    isCompleted: json["is_completed"],
    failedAtRep: json["failed_at_rep"],
    previous: json["previous"],
    setImage: json["set_image"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "set_number": setNumber,
    "set_type": setType,
    "set_type_display": setTypeDisplay,
    "weight_kg": weightKg,
    "reps": reps,
    "distance_km": distanceKm,
    "time_seconds": timeSeconds,
    "is_completed": isCompleted,
    "failed_at_rep": failedAtRep,
    "previous": previous,
    "set_image": setImage,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}