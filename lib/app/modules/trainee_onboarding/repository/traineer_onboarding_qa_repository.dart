import '../models/trainee_onboarding_questions_model.dart';

abstract class TraineeOnboardingQARepository{

Future<TraineeOnboardingQuestionsModel> fetchQuestionsData(int trainerId); // Default id is 1
}