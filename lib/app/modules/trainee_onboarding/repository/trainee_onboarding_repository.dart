abstract class TraineeOnboardingRepository{
  Future<void> createTraineeProfile(Map<String, dynamic> data);
  Future<void> createTraineePreferences(Map<String, dynamic> data);
}