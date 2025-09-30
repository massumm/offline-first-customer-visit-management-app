import '../models/trainee_profile_create_model.dart';
import '../models/trainee_profile_create_response_model.dart';

abstract class TraineeOnboardingRepository{
  Future<TraineeProfileCreateResponseModel>
  createTraineeProfile(TraineeProfileCreateModel model);
}