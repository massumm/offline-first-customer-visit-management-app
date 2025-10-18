import 'package:get/get.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository_impl.dart';
import '../controllers/profile_create_animation_controller.dart';

class ProfileCreateAnimationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraineeOnboardingRepository>(
          () => TraineeOnboardingRepositoryImpl(),
      tag: (TraineeOnboardingRepository).toString(),
    );


    Get.lazyPut<ProfileCreateAnimationController>(
      () => ProfileCreateAnimationController(),
    );
  }
}
