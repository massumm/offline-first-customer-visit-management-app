import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart';
import '../../../trainer_onboarding/views/screens/trainer_onboarding_full_name.dart';
import 'trainee_onboarding_time_prefer_train_screen.dart';

class TraineeOnboardingIntenseSessionBeScreen extends GetView<TraineeOnboardingController>  {
  const TraineeOnboardingIntenseSessionBeScreen({super.key});

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
                "How intense would you like your sessions to be?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
              ),
            ),
            20.height,
            _buildSliderRow("Light", "Hard", controller.warmDirect),
            20.height,
            ElevatedButton(
              onPressed: () {
                Get.to(() => TraineeOnboardingTimePreferTrainScreen());
              },
              child: const Text('Next'),
            ),
            40.height,
          ],
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
              Text("1", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("2", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("3", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("4", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("5", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("6", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("7", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("8", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("9", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
              Text("10", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        26.height,
      ],
    );
  }
}