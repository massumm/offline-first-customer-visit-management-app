import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import '../../../trainer_onboarding/views/screens/trainer_onboarding_full_name.dart';
import 'trainee_onboarding_workouts_anything_screen.dart';

class TraineeOnboardingAbilityConsistentlyScreen
    extends GetView<TraineeOnboardingController>  {
  const TraineeOnboardingAbilityConsistentlyScreen({super.key});

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
            const ProgressBar(currentStep: 2, stepText: "Activity"),
            40.height,
            Spacer(),
            Center(
              child: const Text(
                "What limits your ability to train consistently?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
              ),
            ),
            20.height,
            ...controller.consistentlyAbility.map((option) => Container(
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
                onPressed: () {},
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
            const Text(
              "Other",
              style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.pageBackground),
            ),
            04.height,
            CustomTextField(
              controller: controller.customNumberController,
              label: 'Other',
              hint: '',
            ),
            20.height,
            ElevatedButton(
              onPressed: () {
                Get.to(() => TraineeOnboardingWorkoutsAnythingScreen());
              },
              child: Text('Next'),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}