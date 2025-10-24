import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/coaching_style_screen.dart';

import 'trainer_onboarding_full_name.dart';

class ExtraSupportScreen extends GetView<TrainerOnboardingController> {
  const ExtraSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionPill(onTap: () => Navigator.maybePop(context)),
              30.height,
              const ProgressBar(currentStep: 2, stepText: "Exercise Strategy"),
              70.height,
              Center(
                child: Text(
                  "How do you adapt for clients who need extra support?",
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
                children: controller.extraSupport.map((q) {
                  return Obx(() {
                    final isSelected = controller.selectedQualifications
                        .contains(q);
                    return GestureDetector(
                      onTap: () => controller.toggleQualification(q),
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
                                : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              50.height,
              CustomTextField(
                controller: controller.descriptionController,
                maxLines: 5,
                label: "Description",
                hint: "",
              ),
              20.height,
              // Next Button
              ElevatedButton(
                onPressed: () {
                  Get.to(() => CoachingStyleScreen());
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
