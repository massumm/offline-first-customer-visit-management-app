import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../../../core/widgets/back_pill.dart';
import '../../../../core/widgets/step_progresh_indicator.dart';
import '../../controllers/trainee_onboarding_controller.dart';
import 'trainee_onboarding_partner.dart';

class TraineeOnboardingFitnessExperience extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingFitnessExperience({super.key});

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
              Center(
                child: Text(
                  'Fitness experience',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              8.height,
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  controller.fitnessExperience.value = 'Beginner';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingFitnessPartner()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.fitnessExperience.value == 'Beginner';
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.colorPrimary
                            : Colors.grey.shade600,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Beginner'),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: isSelected
                              ? AppColors.colorPrimary
                              : Colors.grey.shade600,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              8.height,
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  controller.fitnessExperience.value = 'Intermediate';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingFitnessPartner()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.fitnessExperience.value == 'Intermediate';
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.colorPrimary
                            : Colors.grey.shade600,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Intermediate'),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: isSelected
                              ? AppColors.colorPrimary
                              : Colors.grey.shade600,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              8.height,
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  controller.fitnessExperience.value = 'Advanced';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingFitnessPartner()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.fitnessExperience.value == 'Advanced';
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.colorPrimary
                            : Colors.grey.shade600,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Advanced'),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: isSelected
                              ? AppColors.colorPrimary
                              : Colors.grey.shade600,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
