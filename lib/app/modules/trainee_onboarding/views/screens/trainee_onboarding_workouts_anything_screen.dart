import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/success_dialog_screen.dart';

import '../../../trainer_onboarding/views/screens/trainer_onboarding_full_name.dart';

class TraineeOnboardingWorkoutsAnythingScreen
    extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingWorkoutsAnythingScreen({super.key});

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
                "What kind of workouts do you most enjoy, or is there anything you want to try?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.pageBackground,
                ),
              ),
            ),
            30.height,
            CustomTextField(
              controller: controller.descriptionController,
              label: 'Description',
              hint: '',
              maxLines: 8,
            ),
            20.height,
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isButtonLoading.isTrue
                    ? null
                    : () {
                        controller.onDoneButtonPressed();
                      },
                child: controller.isButtonLoading.isTrue
                    ? Padding(
                        padding: EdgeInsets.all(4),
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Text('Complete'),
              );
            }),
            20.height,
          ],
        ),
      ),
    );
  }

  void showSuccessDialog() {
    Get.dialog(
      SuccessDialog(
        onFinish: () {
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
  }
}
