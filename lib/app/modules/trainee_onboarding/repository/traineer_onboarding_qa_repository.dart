import '../models/trainee_onboarding_questions_model.dart';

abstract class TraineeOnboardingQARepository {
  Future<TraineeOnboardingQuestionDataModel> fetchQuestionsData(
    int trainerId,
  ); // Default id is 1

  Future<Map<String, dynamic>> sendAnswers(
      Map<String, dynamic> answers, int traineeId
      );

  Future<Map<String, dynamic>> updateAnswers(
      Map<String, dynamic> answers, int traineeId
      );
}
