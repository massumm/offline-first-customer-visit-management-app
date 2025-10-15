import 'package:get/get.dart';

import '../controllers/trainee_onboarding_controller.dart';

class TraineeOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraineeOnboardingController>(
      () => TraineeOnboardingController(),
    );
  }
}
