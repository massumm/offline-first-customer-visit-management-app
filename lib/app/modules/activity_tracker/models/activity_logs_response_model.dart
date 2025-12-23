import 'package:icon/app/modules/activity_tracker/models/workout_response_model.dart';

class ActivityLogsResponseModel {
  final bool? success;
  final int? count;
  final Stats? stats;
  final List<Workout>? workouts;

  ActivityLogsResponseModel({
    this.success,
    this.count,
    this.stats,
    this.workouts,
  });

  factory ActivityLogsResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivityLogsResponseModel(
        success: json["success"],
        count: json["count"],
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        workouts: json["workouts"] == null
            ? []
            : List<Workout>.from(
                json["workouts"]!.map((x) => Workout.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "stats": stats?.toJson(),
    "workouts": workouts == null
        ? []
        : List<dynamic>.from(workouts!.map((x) => x.toJson())),
  };
}

class Stats {
  final int? active;
  final int? completed;
  final int? cancelled;
  final int? paused;

  Stats({this.active, this.completed, this.cancelled, this.paused});

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    active: json["active"],
    completed: json["completed"],
    cancelled: json["cancelled"],
    paused: json["paused"],
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "completed": completed,
    "cancelled": cancelled,
    "paused": paused,
  };
}
