abstract class TraineeOnboardingAuthRepository{
  Future<Map<String, dynamic>> registerEmail(Map<String, dynamic> payload);
  Future<Map<String, dynamic>> getTokenFromEmail(Map<String, dynamic> payload);
}