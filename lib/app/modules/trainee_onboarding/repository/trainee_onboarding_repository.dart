import '../models/trainee_preference_create_response_model.dart';
import '../models/trainee_profile_create_model.dart';
import '../models/trainee_profile_create_response_model.dart';

abstract class TraineeOnboardingRepository{
  Future<TraineeProfileCreateResponseModel>
  createTraineeProfile(Map<String, dynamic> model);

  Future<TraineePreferenceCreateResponseModel>
  createTraineePreferences(Map<String, dynamic> model);

  Future<void> storeTraineeProfile(TraineeProfileCreateModel traineeProfileCreateModel);

}