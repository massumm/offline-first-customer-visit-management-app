import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../../../core/widgets/back_pill.dart';
import '../../../../core/widgets/step_progresh_indicator.dart';
import '../../controllers/trainee_onboarding_controller.dart';
import 'trainee_onboarding_description.dart';

class TraineeOnboardingFitnessPartner extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingFitnessPartner({super.key});

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
                  'Do you have an accountability partner - somebody to help you with your fitness journey?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              8.height,
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  controller.selectedPartner.value = 'Friends';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingDescriptionView()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.selectedPartner.value == 'Friends';
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
                        Text('Friends'),
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
                  controller.selectedPartner.value = 'Family';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingDescriptionView()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.selectedPartner.value == 'Family';
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
                        Text('Family'),
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
                  controller.selectedPartner.value = 'Personal trainer';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingDescriptionView()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.selectedPartner.value == 'Personal trainer';
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
                        Text('Personal trainer'),
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
                  controller.selectedGender.value = 'None';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingDescriptionView()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.selectedGender.value == 'None';
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
                        Text('None'),
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
              ), 8.height,
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  controller.selectedGender.value = 'Prefer not to say';
                  Future.delayed(Duration(microseconds: 300),
                          () =>  Get.to(() => TraineeOnboardingDescriptionView()));
                },
                child: Obx(() {
                  final isSelected =
                      controller.selectedGender.value == 'Prefer not to say';
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
                        Text('Prefer not to say'),
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
