import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import '../../../trainer_onboarding/views/screens/trainer_onboarding_full_name.dart';
import 'trainee_onboarding_body_parts_focus_screen.dart';

class TraineeOnboardingReminderSelectedTimeScreen extends GetView<TraineeOnboardingController>  {
  const TraineeOnboardingReminderSelectedTimeScreen({super.key});

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
                "Would you like to set a reminder for your selected time?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
              ),
            ),
            20.height,
            Obx(() => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOption(
                    "Yes",
                    isSelected: controller.selectedReminder.value == "Yes",
                    onTap: () => controller.selectedReminder.value = "Yes",
                  ),
                  12.height,
                  _buildOption(
                    "No",
                    isSelected: controller.selectedReminder.value == "No",
                    onTap: () => controller.selectedReminder.value = "No",
                  ),
                  12.height,
                  const Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.pageBackground),
                  ),
                  04.height,
                  _buildOption(
                    controller.selectedReminder.value.isNotEmpty &&
                        controller.selectedReminder.value != "Yes" &&
                        controller.selectedReminder.value != "No"
                        ? controller.selectedReminder.value // যদি time pick করা হয়
                        : "8:00",
                    isSelected: controller.selectedReminder.value != "Yes" &&
                        controller.selectedReminder.value != "No" &&
                        controller.selectedReminder.value.isNotEmpty,
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 8, minute: 0),
                      );
                      if (pickedTime != null) {
                        controller.selectedReminder.value = pickedTime.format(context);
                      } else {
                        controller.selectedReminder.value = "8:00";
                      }
                    },
                  ),
                ],
              ),
            )),
            20.height,
            // Next Button
            ElevatedButton(
              onPressed: () {
                Get.to(() => TraineeOnboardingBodyPartsFocusScreen());
              },
              child: const Text('Next'),
            ),
            30.height,
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String text, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBgColor,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.colorPrimary, width: 1)
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.colorPrimary : AppColors.pageBackground,
          ),
        ),
      ),
    );
  }
}