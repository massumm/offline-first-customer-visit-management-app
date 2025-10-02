import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import '../../../../core/widgets/step_progresh_indicator.dart';
import 'trainee_onboarding_reminder_selected_time_screen.dart';

class TraineeOnboardingTimePreferTrainScreen
    extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingTimePreferTrainScreen({super.key});

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
              currentStep: 14,
              totalSteps: 22,
              percentInStep: 0.10, // 10%
              stepTitle: 'Activity',
            ),
            40.height,
            Spacer(),
            Center(
              child: const Text(
                "What time of day do you prefer to train?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.pageBackground,
                ),
              ),
            ),
            20.height,
            ...controller.timePreferTrain.map(
              (option) => Obx(() {
                final isSelected = controller.selectedPreferredTimeOfDay
                    .contains(option);
                return Container(
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
                      side: isSelected
                          ? BorderSide(color: AppColors.colorPrimary)
                          : BorderSide.none,
                    ),
                    onPressed: () {
                      controller.selectedPreferredTimeOfDay.value = option;
                      Future.delayed(
                        Duration(milliseconds: 300),
                        () => Get.to(
                          () => TraineeOnboardingReminderSelectedTimeScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.pageBackground,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: AppColors.pageBackground,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
