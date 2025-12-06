import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/network/exceptions/not_found_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

import '../repository/trainee_onboarding_by_page_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/trainee_onboarding.dart';

import 'package:icon/app/base/repository/trainee_onboarding_auth_repo/trainee_onboarding_auth_repository_impl.dart';
import 'package:icon/app/base/repository/trainee_onboarding_auth_repo/trainee_onboarding_auth_repository.dart';

class TraineeOnboardingByPageController extends GetxController {
  final TraineeOnboardingByPageRepository repository;
  final TraineeOnboardingAuthRepository authRepository =
      TraineeOnboardingAuthRepositoryImpl();

  TraineeOnboardingByPageController(this.repository);

  final PageController pageController = PageController();

  RxInt currentPage = 0.obs;
  RxString sex = 'Male'.obs;
  Rxn<DateTime> dob = Rxn<DateTime>();
  RxnDouble height = RxnDouble();
  RxnDouble weight = RxnDouble();
  RxnString fitnessGoal = RxnString();
  RxnString lifestyle = RxnString();
  RxInt trainingDays = 1.obs;
  RxnString sessionLength = RxnString();
  RxnString eatingHabits = RxnString();
  RxnString stressLevel = RxnString();
  RxnString sleepQuality = RxnString();
  RxString email = ''.obs;

  void nextPage() {
    if (currentPage.value <= 10) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> submitAnswers() async {
    try {
      final data = TraineeOnboardingDataModel(
        sex: sex.value,
        dob: dob.value,
        height: height.value,
        weight: weight.value,
        fitnessGoal: fitnessGoal.value,
        lifestyle: lifestyle.value,
        trainingDays: trainingDays.value,
        sessionLength: sessionLength.value,
        eatingHabits: eatingHabits.value,
        stressLevel: stressLevel.value,
        sleepQuality: sleepQuality.value,
        email: email.value,
      );

      try {
        "Attempting to register email...".log();
        await authRepository.registerEmail({'email': email.value});
        "Email registered successfully.".log();
      } catch (e) {
        "Registration failed: $e. Assuming user exists, attempting to get token..."
            .log();
        await authRepository.getTokenFromEmail({'email': email.value});
        "Successfully retrieved token for existing user.".log();
      }

      "Submitting onboarding data...".log();
      await repository.submitTraineeOnboardingData(data);
      "Onboarding data submitted successfully.".log();

      Get.offAllNamed('/goal-tracking');
    } catch (e) {
      "An error occurred during the submission process: $e".log();

      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      } else if (e is NotFoundException) {
        CustomToast.showErrorToast(e.description);
      } else {
        Get.snackbar(
          'Submission Failed',
          'We couldn\'t save your information. Please check your network connection and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
