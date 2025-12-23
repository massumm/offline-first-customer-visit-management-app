class ActivityTypeModel {
  final int? id;
  final String? name;

  ActivityTypeModel({this.id, this.name});

  factory ActivityTypeModel.fromJson(Map<String, dynamic> json) =>
      ActivityTypeModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
