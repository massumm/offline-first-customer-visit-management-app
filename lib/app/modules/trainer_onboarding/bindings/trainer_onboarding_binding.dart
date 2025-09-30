import 'package:get/get.dart';

import '../controllers/trainer_onboarding_controller.dart';

class TrainerOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerOnboardingController>(
      () => TrainerOnboardingController(),
    );
  }
}
