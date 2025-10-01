class TraineePreferenceCreateResponseModel {
  TraineePreferenceCreateResponseModel({
    required this.id,
    required this.fitnessExperience,
    required this.accountabilityPartner,
    required this.trainingLocation,
    required this.equipmentAccess,
    required this.preferredTrainingStyle,
    required this.daysPerWeek,
    required this.sessionLength,
    required this.trainingIntensity,
    required this.preferredTimeOfDay,
    required this.createdAt,
    required this.updatedAt,
    required this.trainingReminder,
  });

  final int? id;
  final String? fitnessExperience;
  final String? accountabilityPartner;
  final String? trainingLocation;
  final String? equipmentAccess;
  final String? preferredTrainingStyle;
  final num? daysPerWeek;
  final String? sessionLength;
  final num? trainingIntensity;
  final String? preferredTimeOfDay;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? trainingReminder;

  TraineePreferenceCreateResponseModel copyWith({
    int? id,
    String? fitnessExperience,
    String? accountabilityPartner,
    String? trainingLocation,
    String? equipmentAccess,
    String? preferredTrainingStyle,
    num? daysPerWeek,
    String? sessionLength,
    num? trainingIntensity,
    String? preferredTimeOfDay,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? trainingReminder,
  }) {
    return TraineePreferenceCreateResponseModel(
      id: id ?? this.id,
      fitnessExperience: fitnessExperience ?? this.fitnessExperience,
      accountabilityPartner: accountabilityPartner ?? this.accountabilityPartner,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      equipmentAccess: equipmentAccess ?? this.equipmentAccess,
      preferredTrainingStyle: preferredTrainingStyle ?? this.preferredTrainingStyle,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      sessionLength: sessionLength ?? this.sessionLength,
      trainingIntensity: trainingIntensity ?? this.trainingIntensity,
      preferredTimeOfDay: preferredTimeOfDay ?? this.preferredTimeOfDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      trainingReminder: trainingReminder ?? this.trainingReminder,
    );
  }

  factory TraineePreferenceCreateResponseModel.fromJson(Map<String, dynamic> json){
    return TraineePreferenceCreateResponseModel(
      id: json["id"],
      fitnessExperience: json["fitness_experience"],
      accountabilityPartner: json["accountability_partner"],
      trainingLocation: json["training_location"],
      equipmentAccess: json["equipment_access"],
      preferredTrainingStyle: json["preferred_training_style"],
      daysPerWeek: json["days_per_week"],
      sessionLength: json["session_length"],
      trainingIntensity: json["training_intensity"],
      preferredTimeOfDay: json["preferred_time_of_day"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      trainingReminder: json["training_reminder"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fitness_experience": fitnessExperience,
    "accountability_partner": accountabilityPartner,
    "training_location": trainingLocation,
    "equipment_access": equipmentAccess,
    "preferred_training_style": preferredTrainingStyle,
    "days_per_week": daysPerWeek,
    "session_length": sessionLength,
    "training_intensity": trainingIntensity,
    "preferred_time_of_day": preferredTimeOfDay,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "training_reminder": trainingReminder,
  };

}
