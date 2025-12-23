import 'equipment_model.dart';

class EquipmentResponseModel {
  final String? message;
  final int? count;
  final dynamic next;
  final dynamic previous;
  final List<EquipmentModel>? results;

  EquipmentResponseModel({
    this.message,
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory EquipmentResponseModel.fromJson(Map<String, dynamic> json) =>
      EquipmentResponseModel(
        message: json["message"],
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<EquipmentModel>.from(
                json["results"]!.map((x) => EquipmentModel.fromJson(x)),
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
