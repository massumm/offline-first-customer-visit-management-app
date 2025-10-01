import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/coaching_superpower_screen.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/identity_verification_full_name.dart';

class ToneSlidersScreen extends GetView<TrainerOnboardingController> {
  const ToneSlidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrainerOnboardingController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackPill(onTap: () => Navigator.maybePop(context)),
              30.height,
              const ProgressBar(currentStep: 2, stepText: "Coaching Style & Persona"),
              30.height,
              // Title
              Center(
                child: Text(
                  "Tone sliders",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // fixed
                  ),
                ),
              ),
              24.height,
              _buildSliderRow("Warm", "Direct", controller.warmDirect),
              _buildSliderRow("Formal", "Casual", controller.formalCasual),
              _buildSliderRow("Science-Based", "Preference", controller.sciencePreference),
              _buildSliderRow("Humor", "Seriousness", controller.humorSerious),
              _buildSliderRow("Empathy", "Accountability", controller.empathyAccountability),
              _buildSliderRow("Structure", "Freedom", controller.structureFreedom),
              20.height,
              ElevatedButton(
                onPressed: () {
                  Get.to(() => CoachingSuperpowerScreen());
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

  Widget _buildSliderRow(String leftLabel, String rightLabel, RxDouble value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftLabel, style: TextStyle(fontSize: 16, color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Obx(() => Text(
                value.value.toInt().toString(),
                style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w800, fontSize: 14),
              )),
              Text(rightLabel, style: TextStyle(fontSize: 16, color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Obx(() => Slider(
          value: value.value,
          min: 0,
          max: 10,
          divisions: 10,
          label: value.value.toInt().toString(),
          activeColor: AppColors.colorPrimary,
          inactiveColor: Colors.white30,
          onChanged: (newValue) => value.value = newValue,
          padding: EdgeInsets.zero,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("10", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        26.height,
      ],
    );
  }
}
