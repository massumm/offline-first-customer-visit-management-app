import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';

import '../../../../core/widgets/back_pill.dart';
import '../../../../core/widgets/step_progresh_indicator.dart';
import '../../controllers/trainee_onboarding_controller.dart';


class TraineeOnboardingDescriptionView extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingDescriptionView({super.key});

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
              Text('Who inspires you the most in your fitness journey?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
             12.height,
              CustomTextField(
                controller: controller.nameCtr,
                label: 'Description',
                hint: 'Enter description',
                maxLines: 5,
              ),
              16.height,
              ElevatedButton(
                onPressed: () {

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
