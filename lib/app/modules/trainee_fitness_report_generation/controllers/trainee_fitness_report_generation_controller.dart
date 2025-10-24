import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/utils/app_validators.dart';

import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';
import '../views/saving_view.dart';

class TraineeFitnessReportGenerationController extends BaseController {
  final TraineeOnboardingRepository _repo = Get.find(
    tag: (TraineeOnboardingRepository).toString(),
  );

 final TextEditingController emailCtr = TextEditingController();
  var emailError = RxnString() ;
  final isValidEmail = RxBool(false);

  // --------------- Loading Effect State ---------------
  final progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate progress updates, e.g., from a backend call
    _simulateProgress();
  }

  @override
  void onClose() {
    emailCtr.dispose();
    super.onClose();
  }

  void _simulateProgress() async {
    // This is just an example. In a real app, this would come from
    // actual data saving operations.
    await Future.delayed(const Duration(milliseconds: 500));
    progress.value = 0.1;
    await Future.delayed(const Duration(milliseconds: 800));
    progress.value = 0.3;
    await Future.delayed(const Duration(milliseconds: 1200));
    progress.value = 0.6;
    await Future.delayed(const Duration(milliseconds: 1000));
    progress.value = 0.85;
    await Future.delayed(const Duration(milliseconds: 700));
    progress.value = 1.0; // Complete
    // After completion, you might navigate to another screen
    // Get.offAllNamed('/report_complete');
  }

  // You might also have a method to manually update progress if needed
  void updateProgress(double value) {
    progress.value = value.clamp(0.0, 1.0);
  }
  Future<void> onSubmitButtonPressed() async {
    if (isValidEmail.value) {
       Get.to(() => SavingView());
    }
  }
  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);

    if(emailError.value == null){
      isValidEmail(true);
    }
  }
}
