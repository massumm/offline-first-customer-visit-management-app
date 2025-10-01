class TraineeProfileCreateModel {
  TraineeProfileCreateModel({
    required this.bio,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.fullAddress,
    required this.country,
    required this.city,
    required this.gender,
    required this.experience,
    required this.partner,
    required this.description,
    required this.trainingLocation,
  required this.equipmentAccess,
    required this.preferredTrainingStyle,
  required this.daysPerWeek,
  required this.sessionLength,
  required this.trainingIntensity,
  required this.preferredTimeOfDay,
  required this.trainingReminder,
  });

  final String? bio;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? fullAddress;
  final String? country;
  final String? city;
  final String? gender;
  final String? experience;
  final String? partner;
  final String? description;
  final String? trainingLocation;
  final String? equipmentAccess;
  final String? preferredTrainingStyle;
  final int? daysPerWeek;
  final String? sessionLength;
  final int? trainingIntensity;
  final String? preferredTimeOfDay;
  final bool? trainingReminder;

  TraineeProfileCreateModel copyWith({
    String? bio,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? fullAddress,
    String? country,
    String? city,
    String? gender,
    String? experience,
    String? partner,
    String? description,
    String? trainingLocation,
    String? equipmentAccess,
    String? preferredTrainingStyle,
    int? daysPerWeek,
    String? sessionLength,
    int? trainingIntensity,
    String? preferredTimeOfDay,
    bool? trainingReminder,
  }) {
    return TraineeProfileCreateModel(
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullAddress: fullAddress ?? this.fullAddress,
      country: country ?? this.country,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      experience: experience ?? this.experience,
      partner: partner ?? this.partner,
      description: description ?? this.description,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      equipmentAccess: equipmentAccess ?? this.equipmentAccess,
      preferredTrainingStyle: preferredTrainingStyle ?? this.preferredTrainingStyle,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      sessionLength: sessionLength ?? this.sessionLength,
      trainingIntensity: trainingIntensity ?? this.trainingIntensity,
      preferredTimeOfDay: preferredTimeOfDay ?? this.preferredTimeOfDay,
      trainingReminder: trainingReminder ?? this.trainingReminder,
    );
  }

  factory TraineeProfileCreateModel.fromJson(Map<String, dynamic> json){
    return TraineeProfileCreateModel(
      bio: json["bio"],
      dateOfBirth: DateTime.tryParse(json["date_of_birth"] ?? ""),
      phoneNumber: json["phone_number"],
      fullAddress: json["full_address"],
      country: json["country"],
      city: json["city"],
      gender: json["gender"],
      experience: json["experience"],
      partner: json["partner"],
      description: json["description"],
      trainingLocation: json["training_location"],
      equipmentAccess: json["equipment_access"],
      preferredTrainingStyle: json["preferred_training_style"],
      daysPerWeek: json["days_per_week"],
      sessionLength: json["session_length"],
      trainingIntensity: json["training_intensity"],
      preferredTimeOfDay: json["preferred_time_of_day"],
      trainingReminder: json["training_reminder"],
    );
  }

  // In your TraineeProfileCreateModel class
  Map<String, dynamic> toJson() => {
    "bio": bio,
    "date_of_birth": dateOfBirth == null
        ? null
        : "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "phone_number": phoneNumber,
    "full_address": fullAddress,
    "country": country,
    "city": city,
    "gender": gender?.toLowerCase(),
    "fitness_experience": experience?.toLowerCase(),
    "accountability_partner": partner?.toLowerCase(),
    "description": description,
    "training_location": trainingLocation,
    "equipment_access": equipmentAccess,
    "preferred_training_style": preferredTrainingStyle,
    "days_per_week": daysPerWeek,
    "session_length": sessionLength,
    "training_intensity": trainingIntensity,
    "preferred_time_of_day": preferredTimeOfDay,
    "training_reminder": trainingReminder,
  };




}
