class DailyGoalModel {
  final int id;
  final String section;
  final String title;
  final String value;
  final String description;
  final String frequency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyGoalModel({
    required this.id,
    required this.section,
    required this.title,
    required this.value,
    required this.description,
    required this.frequency,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel(
      id: json['id'],
      section: json['section'],
      title: json['title'],
      value: json['value'],
      description: json['description'],
      frequency: json['frequency'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section': section,
      'title': title,
      'value': value,
      'description': description,
      'frequency': frequency,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
