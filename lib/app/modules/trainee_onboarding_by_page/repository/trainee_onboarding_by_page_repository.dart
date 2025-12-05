import '../models/trainee_onboarding.dart';

abstract class TraineeOnboardingByPageRepository {
  Future<void> submitTraineeOnboardingData(TraineeOnboardingDataModel data);
}
