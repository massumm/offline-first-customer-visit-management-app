import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';

import '../../../core/widgets/back_pill.dart';
import '../../../core/widgets/step_progresh_indicator.dart';
import '../controllers/trainee_onboarding_controller.dart';
import 'screens/trainee_onboarding_dob_view.dart';

class TraineeOnboardingView extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackPill(onTap: () => Navigator.maybePop(context)),
              16.height,
              StepProgressIndicator(
                currentStep: 1,
                totalSteps: 6,
                percentInStep: 0.10, // 10%
                stepTitle: 'Personal',
              ),
              Spacer(),
              CustomTextField(
                controller: controller.nameCtr,
                label: 'Full Name',
                hint: 'Your Name',
              ),
              16.height,
              ElevatedButton(
                onPressed: () {
                  Get.to(() => TraineeOnboardingDOFBView());
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
