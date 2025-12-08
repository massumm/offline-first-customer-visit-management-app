
class DailyGoalModel {
  final int id;
  final String section;
  final String identifier;
  final String title;
  final String value;
  final String description;
  final String frequency;
  final bool isActive;

  final String color;
  final String icon;

  DailyGoalModel({
    required this.id,
    required this.section,
    required this.identifier,
    required this.title,
    required this.value,
    required this.description,
    required this.frequency,
    required this.isActive,
    required this.color,
    required this.icon,
  });

  /// Factory constructor to create a DailyGoalModel from JSON.
  /// It now handles the missing 'identifier', 'color', and 'icon' fields.
  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    final section = json['section'] as String? ?? 'Other';
    final title = json['title'] as String? ?? '';

    // Determine color and icon based on the goal's section
    final Map<String, String> presentation = _getPresentation(section, title);

    return DailyGoalModel(
      id: json['id'] as int,
      section: section,
      // Use the 'id' from the JSON as the unique identifier.
      identifier: (json['id'] as int).toString(),
      title: title,
      value: json['value'] as String? ?? '',
      description: json['description'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      color: presentation['color']!,
      icon: presentation['icon']!,
    );
  }

  /// A helper method to determine the color and icon for a goal.
  /// This keeps presentation logic coupled with the model.
  static Map<String, String> _getPresentation(String section, String title) {
    // Default values
    String color = '#808080'; // Grey
    String icon = 'help_outline';

    // Determine color by section
    switch (section.toLowerCase()) {
      case 'workout':
        color = '#E44933'; // Red-Orange
        break;
      case 'nutrition':
        color = '#34A853'; // Green
        break;
      case 'mood & recovery':
        color = '#4285F4'; // Blue
        break;
    }

    // Determine a more specific icon by title keywords
    final titleLower = title.toLowerCase();
    if (titleLower.contains('steps')) {
      icon = 'directions_walk';
    } else if (titleLower.contains('workout')) {
      icon = 'fitness_center';
    } else if (titleLower.contains('calorie')) {
      icon = 'local_fire_department';
    } else if (titleLower.contains('protein')) {
      icon = 'egg_outlined';
    } else if (titleLower.contains('water')) {
      icon = 'water_drop';
    } else if (titleLower.contains('sleep') || titleLower.contains('repair')) {
      icon = 'self_improvement';
    }

    return {'color': color, 'icon': icon};
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'section': section,
    'identifier': identifier,
    'title': title,
    'value': value,
    'description': description,
    'frequency': frequency,
    'is_active': isActive,
  };
}
