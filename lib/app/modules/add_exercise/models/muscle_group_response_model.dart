import 'muscle_group_model.dart';

class MuscleGroupResponseModel {
  final String? message;
  final int? count;
  final dynamic next;
  final dynamic previous;
  final List<MuscleGroupModel>? results;

  MuscleGroupResponseModel({
    this.message,
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory MuscleGroupResponseModel.fromJson(Map<String, dynamic> json) =>
      MuscleGroupResponseModel(
        message: json["message"],
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<MuscleGroupModel>.from(
                json["results"]!.map((x) => MuscleGroupModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}
