// onboarding_header.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../../../core/widgets/action_pill.dart';
import '../../controllers/trainee_onboarding_controller.dart';
import 'animated_onboarding_stepper.dart';

class OnboardingHeader extends StatelessWidget {
  final String avatarAsset;
  final String name;
  final String statusText;
  final Color statusColor;
  final String sectionTitle;
  final int totalSteps;
  final int currentStep;
  final double stepProgress;
  final TraineeOnboardingController controller;

  const OnboardingHeader({
    super.key,
    required this.avatarAsset,
    required this.name,
    required this.statusText,
    required this.totalSteps,
    required this.currentStep,
    required this.stepProgress,
    required this.controller,
    this.statusColor = const Color(0xff2FFF3C),
    this.sectionTitle = 'Personal',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sectionTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          AnimatedOnboardingStepper(
            totalSteps: totalSteps,
            currentStep: currentStep,
            stepProgress: stepProgress,
          ),
          const SizedBox(height: 12),
          // Avatar + name + status
          Row(
            children: [
              Obx(
                () => controller.canGoBack
                    ? Center(
                        child: SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: ActionPill(
                            onTap: controller.goBack,
                            icon: Icons.undo,
                          ),
                        ),
                      )
                    : Center(
                        child: SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: ActionPill(onTap: Get.back),
                        ),
                      ),
              ),
              12.width,
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(avatarAsset),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Spacer(),
              if (controller.currentQuestion?.canSkip ?? false) ...[
                TextButton(
                  onPressed: () {
                    controller.send('');
                  },
                  child: const Text('Skip'),
                ),
              ],
            ],
          ),
          Divider(color: Theme.of(context).dividerTheme.color, height: 24),
        ],
      ),
    );
  }
}
