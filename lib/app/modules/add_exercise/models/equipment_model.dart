class EquipmentModel {
  final int? id;
  final String? name;
  final String? iconImage;
  final String? iconText;

  EquipmentModel({this.id, this.name, this.iconImage, this.iconText});

  factory EquipmentModel.fromJson(Map<String, dynamic> json) => EquipmentModel(
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
