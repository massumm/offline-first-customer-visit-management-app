import 'package:get/get.dart';
import '../controllers/trainee_onboarding_controller.dart';
import '../repository/trainee_onboarding_qa_repository_impl.dart';
import '../repository/traineer_onboarding_qa_repository.dart';

class TraineeOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // ------------- Repository ------------------
    Get.lazyPut<TraineeOnboardingQARepository>(
      () => TraineeOnboardingQARepositoryImpl(),
      tag: (TraineeOnboardingQARepository).toString(),
    );

    Get.lazyPut<TraineeOnboardingController>(
      () => TraineeOnboardingController(),
    );
  }
}
