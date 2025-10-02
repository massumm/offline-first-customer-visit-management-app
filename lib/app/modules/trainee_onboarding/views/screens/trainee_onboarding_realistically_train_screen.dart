import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import 'package:icon/app/modules/trainee_onboarding/views/screens/trainee_onboarding_session_be_screen.dart';

import '../../../trainer_onboarding/views/screens/trainer_onboarding_full_name.dart';

class TraineeOnboardingRealisticallyTrainScreen
    extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingRealisticallyTrainScreen({super.key});

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
                "How many days per week can you realistically train?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.pageBackground,
                ),
              ),
            ),
            20.height,
            ...controller.realisticallyTrain.map(
              (option) => Obx(() {
                final isSelected = controller.selectedDaysPerWeek.contains(
                  option,
                );
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
                          : null,
                    ),
                    onPressed: () {
                      controller.selectedDaysPerWeek(option);

                      Future.delayed(
                        Duration(milliseconds: 300),
                        () => Get.to(() => TraineeOnboardingSessionBeScreen()),
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
