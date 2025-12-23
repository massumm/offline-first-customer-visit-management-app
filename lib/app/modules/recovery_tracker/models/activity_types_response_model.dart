import 'activity_type_model.dart';

class ActivityTypesResponseModel {
  final String? message;
  final int? count;
  final List<ActivityTypeModel>? results;

  ActivityTypesResponseModel({this.message, this.count, this.results});

  factory ActivityTypesResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivityTypesResponseModel(
        message: json["message"],
        count: json["count"],
        results: json["results"] == null
            ? []
            : List<ActivityTypeModel>.from(
                json["results"]!.map((x) => ActivityTypeModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "count": count,
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}
