import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import 'package:icon/app/modules/trainee_onboarding/views/screens/trainee_onboarding_realistically_train_screen.dart';

import '../../../../core/widgets/step_progresh_indicator.dart';

class TraineeOnboardingEquipmentAccessScreen
    extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingEquipmentAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackPill(onTap: () => Navigator.maybePop(context)),
              30.height,
              StepProgressIndicator(
                currentStep: 10,
                totalSteps: 22,
                percentInStep: 0.10, // 10%
                stepTitle: 'Activity',
              ),
              330.height,
              Center(
                child: Text(
                  "What equipment do you have access to at home?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.pageBackground,
                  ),
                ),
              ),
              20.height,
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: controller.equipmentAccess.map((q) {
                  return Obx(() {
                    final isSelected = controller.selectedEquipment
                        .contains(q);
                    return GestureDetector(
                      onTap: () => controller.selectedEquipment(q),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.cardBgColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 1.5,
                            color: isSelected
                                ? Colors.deepOrange
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          q,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.deepOrange
                                : AppColors.pageBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              50.height,
              Text(
                "Other equipment",
                style: TextStyle(
                  color: AppColors.pageBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              06.height,
              CustomTextField(
                controller: controller.otherController,
                label: "Other",
                hint: "",
              ),
              20.height,
              // Next Button
              ElevatedButton(
                onPressed: () {
                  Get.to(() => TraineeOnboardingRealisticallyTrainScreen());
                },
                child: const Text('Next'),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
