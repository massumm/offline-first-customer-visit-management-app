class DailyGoalModel {
  final String section;
  final String identifier;
  final String title;
  final String value;
  final String description;
  final String frequency;
  final bool isActive;

  DailyGoalModel({
    required this.section,
    required this.identifier,
    required this.title,
    required this.value,
    required this.description,
    required this.frequency,
    required this.isActive,
  });

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel(
      section: json['section'] as String,
      identifier: json['identifier'] as String,
      title: json['title'] as String,
      value: json['value'] as String,
      description: json['description'] as String,
      frequency: json['frequency'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'section': section,
    'identifier': identifier,
    'title': title,
    'value': value,
    'description': description,
    'frequency': frequency,
    'is_active': isActive,
  };
}
