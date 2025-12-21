class MuscleGroupResponseModel {
  final String? message;
  final int? count;
  final dynamic next;
  final dynamic previous;
  final List<Muscle>? results;

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
            : List<Muscle>.from(
                json["results"]!.map((x) => Muscle.fromJson(x)),
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

class Muscle {
  final int? id;
  final String? name;
  final dynamic iconImage;
  final String? iconText;

  Muscle({this.id, this.name, this.iconImage, this.iconText});

  factory Muscle.fromJson(Map<String, dynamic> json) => Muscle(
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
