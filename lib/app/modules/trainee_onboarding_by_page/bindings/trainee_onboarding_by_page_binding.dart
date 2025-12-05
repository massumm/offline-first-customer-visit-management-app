import 'package:get/get.dart';

import '../controllers/trainee_onboarding_by_page_controller.dart';
import '../repository/trainee_onboarding_by_page_repository_impl.dart';
import '../repository/trainee_onboarding_by_page_repository.dart';

class TraineeOnboardingByPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraineeOnboardingByPageRepository>(
      () => TraineeOnboardingByPageRepositoryImpl(),
    );
    Get.lazyPut<TraineeOnboardingByPageController>(
      () => TraineeOnboardingByPageController(
        Get.find<TraineeOnboardingByPageRepository>(),
      ),
    );
  }
}
