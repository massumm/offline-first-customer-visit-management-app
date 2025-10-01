import 'package:get/get.dart';

import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository_impl.dart';
import '../controllers/login_controller.dart';
import '../repository/login_repository.dart';
import '../repository/login_repository_impl.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // ............. Repository ............
    Get.lazyPut<LoginRepository>(
          () => LoginRepositoryImpl(),
      tag: (LoginRepository).toString(),
    );
    Get.lazyPut<TraineeOnboardingRepository>(
          () => TraineeOnboardingRepositoryImpl(),
      tag: (TraineeOnboardingRepository).toString(),
    );

    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
