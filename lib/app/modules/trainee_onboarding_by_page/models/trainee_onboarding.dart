import 'package:intl/intl.dart';

class TraineeOnboardingDataModel {
  final String sex;
  final DateTime? dob;
  final double? height;
  final double? weight;
  final String? fitnessGoal;
  final String? lifestyle;
  final int trainingDays;
  final String? sessionLength;
  final String? eatingHabits;
  final String? stressLevel;
  final String? sleepQuality;
  final String? email;
  final int? traineeProfile;

  const TraineeOnboardingDataModel({
    required this.sex,
    this.dob,
    this.height,
    this.weight,
    this.fitnessGoal,
    this.lifestyle,
    required this.trainingDays,
    this.sessionLength,
    this.eatingHabits,
    this.stressLevel,
    this.sleepQuality,
    this.email,
    required this.traineeProfile,
  });

  factory TraineeOnboardingDataModel.fromJson(Map<String, dynamic> json) {
    return TraineeOnboardingDataModel(
      sex: json['sex'] as String,
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      fitnessGoal: json['fitnessGoal'] as String?,
      lifestyle: json['lifestyle'] as String?,
      trainingDays: json['trainingDays'] as int? ?? 1,
      sessionLength: json['sessionLength'] as String?,
      eatingHabits: json['eatingHabits'] as String?,
      stressLevel: json['stressLevel'] as String?,
      sleepQuality: json['sleepQuality'] as String?,
      email: json['email'] as String?,
      traineeProfile: json['traineeProfile'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'sex': sex,
    'dob': dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : null,
    'height': height,
    'weight': weight,
    'fitnessGoal': fitnessGoal,
    'lifestyle': lifestyle,
    'trainingDays': trainingDays,
    'sessionLength': sessionLength,
    'eatingHabits': eatingHabits,
    'stressLevel': stressLevel,
    'sleepQuality': sleepQuality,
    'email': email,
    'trainee_profile': traineeProfile,
  };
}
