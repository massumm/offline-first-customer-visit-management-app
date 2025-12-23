class MuscleGroupModel {
  final int? id;
  final String? name;
  final dynamic iconImage;
  final String? iconText;

  MuscleGroupModel({this.id, this.name, this.iconImage, this.iconText});

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) =>
      MuscleGroupModel(
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
