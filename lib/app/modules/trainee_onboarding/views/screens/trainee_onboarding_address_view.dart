import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';

import '../../../../core/widgets/back_pill.dart';
import '../../../../core/widgets/step_progresh_indicator.dart';
import '../../controllers/trainee_onboarding_controller.dart';

import 'trainee_onboarding__fitness_experience.dart';

class TraineeOnboardingAddressView
    extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingAddressView({super.key});

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
                controller: controller.addressCtr,
                label: 'Full Address',
                hint: 'Address',
              ),
              12.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.cityCtr,
                      label: 'City',
                      hint: 'City',
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: CustomTextField(
                      controller: controller.countryCtr,
                      label: 'Country',
                      hint: 'Country',
                    ),
                  ),
                ],
              ),
              16.height,
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isButtonLoading.isTrue
                      ? null
                      : () {
                           controller.onDoneButtonPressed();
                          //  Get.to(() => TraineeOnboardingFitnessExperience());
                        },

                  child:  controller.isButtonLoading.isTrue
                      ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: const CircularProgressIndicator.adaptive(),
                      )
                      : Text('Done'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
