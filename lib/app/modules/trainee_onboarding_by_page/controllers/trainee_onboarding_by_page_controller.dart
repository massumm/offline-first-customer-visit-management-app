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
      await authRepository.registerEmail({'email': email.value});
    } catch (e) {
      await authRepository.getTokenFromEmail({'email': email.value});
    }
    await repository.submitTraineeOnboardingData(data);

    Get.offAllNamed('/goal-tracking');
  }
}
