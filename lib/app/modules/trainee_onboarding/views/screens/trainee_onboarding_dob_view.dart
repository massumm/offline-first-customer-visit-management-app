import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:intl/intl.dart'; // Import the intl package

import '../../../../core/widgets/back_pill.dart';
import '../../../../core/widgets/step_progresh_indicator.dart';
import '../../controllers/trainee_onboarding_controller.dart';

class TraineeOnboardingDOFBView extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingDOFBView({super.key});

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
              Text('Date of Birth'),
              8.height,
              InkWell(
                onTap: () => controller.pickDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade600,
                        width: 1,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return Text(
                          controller.selectedDate.value != null
                              ? DateFormat('dd/MM/yyyy') // Format the date
                              .format(controller.selectedDate.value!)
                              : 'dd/mm/yyyy',
                        );
                      }),
                      Icon(
                        Icons.calendar_month,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
              16.height,
              ElevatedButton(onPressed: () {}, child: Text('Next')),
            ],
          ),
        ),
      ),
    );
  }
}
