import '../models/trainee_preference_create_response_model.dart';
import '../models/trainee_profile_create_response_model.dart';

abstract class TraineeOnboardingRepository{
  Future<TraineeProfileCreateResponseModel> createTraineeProfile(Map<String, dynamic> data);
  Future<TraineePreferenceCreateResponseModel> createTraineePreferences(Map<String, dynamic> data);

  Future<Map<String, dynamic>> createTraineePreferenceGoals(Map<String, dynamic> data);
  Future<Map<String, dynamic>> createTraineePreferenceActivity(Map<String, dynamic> data);
  Future<Map<String, dynamic>> createTraineePreferenceNutrition(Map<String, dynamic> data);
  Future<Map<String, dynamic>> createTraineePreferenceRecovery(Map<String, dynamic> data);
}