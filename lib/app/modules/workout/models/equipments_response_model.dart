class EquipmentResponseModel {
  final String? message;
  final int? count;
  final dynamic next;
  final dynamic previous;
  final List<Equipment>? results;

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
            : List<Equipment>.from(
                json["results"]!.map((x) => Equipment.fromJson(x)),
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

class Equipment {
  final int? id;
  final String? name;
  final String? iconImage;
  final String? iconText;

  Equipment({this.id, this.name, this.iconImage, this.iconText});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    id: json["id"],
    name: json["name"],
    iconImage: json["icon_image"],
    iconText: json["icon_text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_image": iconImage,
    "icon_text": iconText,
  };
}
