import 'activity_type_model.dart';

class RecoveryEntry {
  int id; // Changed from String to int
  int user;
  String activityName; // Changed to match "activity_name"
  ActivityTypeModel activityType; // Nested object
  int durationMinutes; // Changed to match "duration_minutes"
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  RecoveryEntry({
    required this.id,
    required this.user,
    required this.activityName,
    required this.activityType,
    required this.durationMinutes,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecoveryEntry.fromJson(Map<String, dynamic> json) => RecoveryEntry(
    id: json["id"],
    user: json["user"],
    activityName: json["activity_name"],
    activityType: ActivityTypeModel.fromJson(json["activity_type"]), // Parse nested object
    durationMinutes: json["duration_minutes"],
    notes: json["notes"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "activity_name": activityName,
    "activity_type": activityType.toJson(),
    "duration_minutes": durationMinutes,
    "notes": notes,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  // Helper for display (remains the same as it uses DateTime properties)
  String get formattedTime {
    final int hour = createdAt.hour % 12 == 0 ? 12 : createdAt.hour % 12;
    final String minute = createdAt.minute.toString().padLeft(2, '0');
    final String ampm = createdAt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $ampm';
  }
}