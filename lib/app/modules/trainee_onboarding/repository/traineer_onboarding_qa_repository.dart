import '../models/trainee_onboarding_questions_model.dart';

abstract class TraineeOnboardingQARepository{

Future<TraineeOnboardingQuestionsModel> getQuestions(int trainerId);
}