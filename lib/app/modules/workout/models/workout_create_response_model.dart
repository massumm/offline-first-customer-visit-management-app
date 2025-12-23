import '../../activity_tracker/models/workout_response_model.dart';

class WorkoutCreateResponseModel {
  WorkoutCreateResponseModel({this.success, this.message, this.workout});

  final bool? success;
  final String? message;
  final Workout? workout;

  factory WorkoutCreateResponseModel.fromJson(Map<String, dynamic> json) =>
      WorkoutCreateResponseModel(
        success: json["success"],
        message: json["message"],
        workout: json["workout"] == null
            ? null
            : Workout.fromJson(json["workout"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "workout": workout?.toJson(),
  };
}
