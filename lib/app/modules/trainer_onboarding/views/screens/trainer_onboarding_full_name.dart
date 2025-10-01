import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/qualifications_screen.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final String stepText;

  const ProgressBar({super.key, required this.currentStep, required this.stepText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Step 2 of 12", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.pageBackground)),
        4.height,
        Row(
          children: List.generate(12, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 20,
                decoration: BoxDecoration(
                  color: index < currentStep ? Colors.deepOrange : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: index == 0 && currentStep == 2
                    ? const Center(
                  child: Text(
                    "10%",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
                    : null,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            stepText,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.pageBackground),
          ),
        ),
      ],
    );
  }
}

class Step1Screen extends GetView<TrainerOnboardingController>  {
  const Step1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackPill(onTap: () => Navigator.maybePop(context)),
            30.height,
            const ProgressBar(currentStep: 2, stepText: "Identity & Verification"),
            40.height,
            Spacer(),
            Center(
              child: const Text(
                "What’s your full legal name?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
              ),
            ),
            20.height,
            CustomTextField(
              controller: controller.nameController,
              label: 'Full name',
              hint: 'Your Name',
            ),
            10.height,
            ElevatedButton(
              onPressed: () {
                Get.to(() => Step2Screen());
              },
              child: const Text('Next'),
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}

class Step2Screen extends GetView<TrainerOnboardingController>  {
  const Step2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackPill(onTap: () => Navigator.maybePop(context)),
            30.height,
            const ProgressBar(currentStep: 2, stepText: "Identity & Verification"),
            40.height,
            Spacer(),
            Center(
              child: const Text(
                "How long have you been coaching?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
              ),
            ),
            20.height,
            ...controller.options.map((option) => Container(
              margin: const EdgeInsets.only(bottom: 14),
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
                  Get.to(() => QualificationsScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(option, style: const TextStyle(fontSize: 16, color: AppColors.subTextColor)),
                    Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppColors.subTextColor),
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
