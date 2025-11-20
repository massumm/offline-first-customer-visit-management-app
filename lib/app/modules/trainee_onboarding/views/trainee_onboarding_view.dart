import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/trainee_onboarding/views/widgets/to_input_widget.dart';

import '../../../../generated/assets.dart';
import '../../../core/widgets/action_pill.dart';
import '../controllers/trainee_onboarding_controller.dart';
import '../models/onboarding_qa_model.dart';
import 'widgets/animated_onboarding_stepper.dart';
import 'widgets/status_image_bubble.dart';
import 'widgets/status_message_bubble.dart';
import 'widgets/type_bubble.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  const TraineeOnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    const double bottomWidgetHeight = 80.0;
    final double totalAppBarHeight = kToolbarHeight + bottomWidgetHeight;

    return PreferredSize(
      preferredSize: Size.fromHeight(totalAppBarHeight),
      child: Obx(() {
        // Adjust on Q. previous button
        final double dynamicLeadingWidth = controller.canGoBack ? 78.0 : 48.0;
        return AppBar(
          title: Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(Assets.imagesIconLogoPink),
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
                        decoration: const BoxDecoration(
                          color: Color(0xff2FFF3C),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              6.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mish Icon',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Online',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          leadingWidth: dynamicLeadingWidth,
          leading: Row(
            children: [
              const SizedBox(width: 8.0),
              SizedBox(
                width: 32.0,
                height: 32.0,
                child: ActionPill(
                  onTap: () => _showExitConfirmationDialog(context),
                ),
              ),

              if (controller.canGoBack)
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: ActionPill(
                      onTap: controller.goBack,
                      icon: Icons.undo,
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            if (controller.currentQuestion?.canSkip ?? false) ...[
              TextButton(
                onPressed: () {
                  controller.send('');
                },
                child: const Text('Skip'),
              ),
            ],
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(bottomWidgetHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  6.height,
                  Text(
                    controller.getCurrentGroupName ?? "Getting Started",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  AnimatedOnboardingStepper(
                    totalSteps: controller.stepperTotalSteps,
                    currentStep: controller.stepperCurrentStep,
                    stepProgress: controller.stepperStepProgress,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    // Check if the user has sent any messages.
    final hasAnswered = controller.messages.any((m) => m.from == Sender.user);

    if (hasAnswered) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, size: 40),
          title: const Text('Leave Onboarding?'),
          content: const Text(
            'Your progress will be lost if you go back. Are you sure?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Stay', style: TextStyle(fontSize: 14)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Get.back();
              },
              child: const Text('Leave', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      );
    } else {
      // If no answers have been provided, navigate back directly.
      Get.back();
    }
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        // ------------------ MESSAGES ----------
        Expanded(
          child: Obx(() {
            // ------------------- DATA STATE ------------------
            final items = controller.messages;
            final typing = controller.isTyping.value;
            return ListView.builder(
              controller: controller.pageController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: items.length + (typing ? 1 : 0),
              itemBuilder: (context, index) {
                final isTypingRow = typing && index == items.length;
                if (isTypingRow) return const TypingBubble();
                final m = items[index];

                final alignment = m.from == Sender.user
                    ? Alignment.centerRight
                    : Alignment.centerLeft;

                Widget bubble;
                if (m.imagePath != null && m.imagePath!.isNotEmpty) {
                  // Use the new status-aware image bubble
                  bubble = StatusImageBubble(
                    imagePath: m.imagePath!,
                    from: m.from,
                    status: m.status,
                  );
                } else {
                  // Use the new status-aware text bubble
                  bubble = StatusMessageBubble(
                    text: m.text,
                    from: m.from,
                    status: m.status,
                  );
                }

                return Align(alignment: alignment, child: bubble);
              },
            );
          }),
        ),

        /// Quick replies (only for choice-type question)
        Obx(() {
          final q = controller.currentQuestion;
          final hasOptions = (q?.metadata?.options?.isNotEmpty ?? false);
          final hasUnitOptions = (q?.metadata?.unitOptions?.isNotEmpty ?? false);
          
          if (controller.onboardingPhase.value !=
                  OnboardingPhase.askingQuestions ||
              controller.isFinished ||
              controller.showGroupContinuationButtons ||
              q == null ||
              (!hasOptions && !hasUnitOptions)) {
            return const SizedBox.shrink();
          }

          // Only show regular options for select_multiple questions
          if (hasOptions && !q.type.supportsOptions) {
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Regular options
              if ((q.metadata?.options?.isNotEmpty ?? false))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children:
                        (q.metadata?.options ?? [])
                            .map(
                              (o) => ActionChip(
                                label: Text(o.toString()),
                                onPressed: () => controller.choose(o.toString()),
                              ),
                            )
                            .toList(),
                  ),
                ),
              
              // Unit options
              // if ((q.metadata?.unitOptions?.isNotEmpty ?? false))
              //   ...[Container(
              //     // height: 400,
              //     width: double.infinity,
              //     padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              //     child: Wrap(
              //       spacing: 8,
              //       runSpacing: 8,
              //       alignment: WrapAlignment.center,
              //       children:
              //           (q.metadata?.unitOptions ?? [])
              //               .map(
              //                 (o) => ActionChip(
              //                   label: Text(o.toJsonString()),
              //                   onPressed: () => controller.choose(o.toJsonString()),
              //                 ),
              //               )
              //               .toList(),
              //     ),
              //   ),
              //     Text('170 cm', style: AppTextTheme.headlineLargeSemiBold,),
              //     8.height,
              //     TapeSlider(
              //       initialValue: 170.0,
              //       minValue: 120.0,
              //       maxValue: 250.0,
              //       onValueChanged: (value) {
              //         print('Selected value: $value');
              //       },
              //       majorTickLabelStyle: AppTextTheme.labelSmallSemiBold.copyWith(color: AppColors.colorPrimary),
              //     )
              //   ],
              
              if ((q.metadata?.options?.isNotEmpty ?? false) ||
                  (q.metadata?.unitOptions?.isNotEmpty ?? false))
                8.height,
            ],
          );
        }),

        // ----------------- Input Sections ----------
        ToInputWidget(),
        const SizedBox(height: 8),
      ],
    );
  }
}
