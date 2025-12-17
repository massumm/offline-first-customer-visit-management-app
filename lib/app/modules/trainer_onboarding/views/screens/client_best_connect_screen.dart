import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/show_up_off_day_screen.dart';

import 'trainer_onboarding_full_name.dart';

class ClientBestConnectScreen extends GetView<TrainerOnboardingController> {
  const ClientBestConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionButton(onTap: () => Navigator.maybePop(context)),
              30.height,
              const ProgressBar(
                currentStep: 2,
                stepText: "Coaching Style & Persona",
              ),
              350.height,
              // Title
              Center(
                child: Text(
                  "Which clients do you best connect with?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // fixed
                  ),
                ),
              ),
              16.height,
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: controller.clientBestConnect.map((q) {
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
              16.height,
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: CustomTextField(
                      controller: controller.customController,
                      label: "Custom",
                      hint: "",
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
              16.height,
              ElevatedButton(
                onPressed: () {
                  Get.to(() => ShowUpOffDayScreen());
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
