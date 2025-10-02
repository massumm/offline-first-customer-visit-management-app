import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import '../../../../core/widgets/step_progresh_indicator.dart';
import '../../../trainer_onboarding/views/screens/trainer_onboarding_full_name.dart';
import 'trainee_onboarding_general_lifestyle_occupation_screen.dart';

class TraineeOnboardingOccupationTrainingScreen extends GetView<TraineeOnboardingController>  {
  const TraineeOnboardingOccupationTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TraineeOnboardingController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackPill(onTap: () => Navigator.maybePop(context)),
            30.height,
            StepProgressIndicator(
              currentStep: 18,
              totalSteps: 22,
              percentInStep: 0.10, // 10%
              stepTitle: 'Activity',
            ),
            40.height,
            Spacer(),
            Center(
              child: const Text(
                "Outside of training, how active is your occupation?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
              ),
            ),
            20.height,
            ...controller.occupationTraining.map((option) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greyColor1,
                  foregroundColor: AppColors.pageBackground,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.to(() => TraineeOnboardingGeneralLifestyleOccupationScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(option, style: const TextStyle(fontSize: 16, color: AppColors.pageBackground)),
                    Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppColors.pageBackground),
                  ],
                ),
              ),
            )),
            20.height,
          ],
        ),
      ),
    );
  }
}