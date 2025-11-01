import 'package:get/get.dart';
import 'package:icon/app/base/repository/trainee_onboarding_auth_repo/trainee_onboarding_auth_repo.dart';

import '../../fitness_report/repository/fitness_report_repository.dart';
import '../../fitness_report/repository/fitness_report_repository_impl.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository_impl.dart';
import '../controllers/trainee_fitness_report_generation_controller.dart';

class TraineeFitnessReportGenerationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraineeOnboardingRepository>(
          () => TraineeOnboardingRepositoryImpl(),
      tag: (TraineeOnboardingRepository).toString(),
    );

    Get.lazyPut<TraineeOnboardingAuthRepository>(
          () => TraineeOnboardingAuthRepositoryImpl(),
      tag: (TraineeOnboardingAuthRepository).toString(),
    );

    Get.lazyPut<FitnessReportRepository>(
          () => FitnessReportRepositoryImpl(),
      tag: (FitnessReportRepository).toString(),
    );



    Get.lazyPut<TraineeFitnessReportGenerationController>(
      () => TraineeFitnessReportGenerationController(),
    );
  }
}
