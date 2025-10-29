import 'package:get/get.dart';

import '../controllers/trainee_onboarding_controller.dart';
import '../repository/trainee_onboarding_repository.dart';
import '../repository/trainee_onboarding_repository_impl.dart';

class TraineeOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // ------------- Repository ------------------
    Get.lazyPut<TraineeOnboardingRepository>(
      () => TraineeOnboardingRepositoryImpl(),
      tag: (TraineeOnboardingRepository).toString(),
    );

    Get.lazyPut<TraineeOnboardingController>(
      () => TraineeOnboardingController(),
    );
  }
}
