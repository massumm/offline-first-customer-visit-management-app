import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/training_plans_screen.dart';

import 'trainer_onboarding_full_name.dart';

class SpecialismScreen extends GetView<TrainerOnboardingController> {
  const SpecialismScreen({super.key});

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
              const ProgressBar(currentStep: 2, stepText: "Identity & Verification"),
              70.height,
              Center(
                child: Text(
                  "What’s your area of specialism?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
                ),
              ),
              20.height,
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: controller.specialism.map((q) {
                  return Obx(() {
                    final isSelected = controller.selectedQualifications.contains(q);
                    return GestureDetector(
                      onTap: () => controller.toggleQualification(q),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.transparent : AppColors.cardBgColor,
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
                            color: isSelected ? Colors.deepOrange : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              50.height,
              Text("Other", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w500)),
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
                  Get.to(() => TrainingPlansScreen());
                },
                child: const Text('Next Step'),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
