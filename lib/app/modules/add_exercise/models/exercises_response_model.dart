import 'equipment_model.dart';
import 'muscle_group_model.dart';

class ExercisesResponseModel {
  final String? message;
  final int? count;
  final dynamic next;
  final dynamic previous;
  final List<Exercise>? recent;
  final List<Exercise>? results;

  ExercisesResponseModel({
    this.message,
    this.count,
    this.next,
    this.previous,
    this.recent,
    this.results,
  });

  factory ExercisesResponseModel.fromJson(Map<String, dynamic> json) =>
      ExercisesResponseModel(
        message: json["message"],
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        recent: json["recent"] == null
            ? []
            : List<Exercise>.from(
                json["recent"]!.map((x) => Exercise.fromJson(x)),
              ),
        results: json["results"] == null
            ? []
            : List<Exercise>.from(
                json["results"]!.map((x) => Exercise.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "count": count,
    "next": next,
    "previous": previous,
    "recent": recent == null
        ? []
        : List<dynamic>.from(recent!.map((x) => x.toJson())),
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Exercise {
  final int? id;
  final String? name;
  final List<MuscleGroupModel>? muscleGroup;
  final List<EquipmentModel>? equipment;
  final bool? isPopular;
  final String? exerciseImage;
  final bool? supportsWeight;
  final bool? supportsReps;
  final bool? supportsDistance;
  final bool? supportsTime;

  Exercise({
    this.id,
    this.name,
    this.muscleGroup,
    this.equipment,
    this.isPopular,
    this.exerciseImage,
    this.supportsWeight,
    this.supportsReps,
    this.supportsDistance,
    this.supportsTime,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json["id"],
    name: json["name"],
    muscleGroup: json["muscle_group"] == null
        ? []
        : List<MuscleGroupModel>.from(
            json["muscle_group"]!.map((x) => MuscleGroupModel.fromJson(x)),
          ),
    equipment: json["equipment"] == null
        ? []
        : List<EquipmentModel>.from(
            json["equipment"]!.map((x) => EquipmentModel.fromJson(x)),
          ),
    isPopular: json["is_popular"],
    exerciseImage: json["exercise_image"],
    supportsWeight: json["supports_weight"],
    supportsReps: json["supports_reps"],
    supportsDistance: json["supports_distance"],
    supportsTime: json["supports_time"],
  );

  Map<String, dynamic> toJson() => {
    "exercise_id": id, // important for create exercise
    "name": name,
    "muscle_group": muscleGroup == null
        ? []
        : List<dynamic>.from(muscleGroup!.map((x) => x.toJson())),
    "equipment": equipment == null
        ? []
        : List<dynamic>.from(equipment!.map((x) => x.toJson())),
    "is_popular": isPopular,
    "exercise_image": exerciseImage,
    "supports_weight": supportsWeight,
    "supports_reps": supportsReps,
    "supports_distance": supportsDistance,
    "supports_time": supportsTime,
  };
}
