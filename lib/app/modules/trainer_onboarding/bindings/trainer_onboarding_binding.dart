import 'package:get/get.dart';

import '../controllers/trainer_onboarding_controller.dart';
import '../repository/tainer_onboarding_repository.dart';
import '../repository/trainer_onboarding_repository_impl.dart';

class TrainerOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerOnboardingRepository>(
          () => TrainerOnboardingRepositoryImpl(),
      tag: (TrainerOnboardingRepository).toString(),
    );

    Get.lazyPut<TrainerOnboardingController>(
      () => TrainerOnboardingController(),
    );
  }
}
