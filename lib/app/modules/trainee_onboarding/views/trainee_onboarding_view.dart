import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/trainee_onboarding/views/widgets/to_input_widget.dart';

import '../../../../generated/assets.dart';
import '../../../core/widgets/action_pill.dart';
import '../controllers/trainee_onboarding_controller.dart';
import '../models/onboarding_qa_model.dart';
import '../models/trainee_onboarding_questions_model.dart';
import 'widgets/animated_onboarding_stepper.dart';
import 'widgets/message_bubble.dart';
import 'widgets/type_bubble.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  TraineeOnboardingView({super.key});

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
              child: const Text('Stay'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Get.back();
              },
              child: const Text('Leave'),
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
                  bubble = _StatusImageBubble(
                    imagePath: m.imagePath!,
                    from: m.from,
                    status: m.status,
                  );
                } else {
                  // Use the new status-aware text bubble
                  bubble = _StatusMessageBubble(
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
          if (controller.onboardingPhase.value !=
                  OnboardingPhase.askingQuestions ||
              controller.isFinished ||
              controller.showGroupContinuationButtons ||
              q == null ||
              q.type != QAType.multipleChoice) {
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: q.options
                      .map(
                        (o) => ActionChip(
                          label: Text(o),
                          onPressed: () => controller.choose(o),
                        ),
                      )
                      .toList(),
                ),
              ),
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

class _StatusImageBubble extends StatelessWidget {
  final String imagePath;
  final Sender from;
  final Rx<MessageStatus> status;

  const _StatusImageBubble({
    required this.imagePath,
    required this.from,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = from == Sender.user;

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return frame == null
              ? const Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              : child;
        },
        errorBuilder: (context, error, stackTrace) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Icon(Icons.broken_image, color: Colors.red, size: 40),
          );
        },
      ),
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isUser
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: isUser
          ? Obx(
              () => Stack(
                children: [
                  imageWidget,
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _MessageStatusIcon(
                      status: status.value,
                      isForImage: true,
                    ),
                  ),
                ],
              ),
            )
          : imageWidget,
    );
  }
}

class _MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;
  final bool isForImage;

  const _MessageStatusIcon({required this.status, this.isForImage = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData iconData;
    Color iconColor;

    switch (status) {
      case MessageStatus.pending:
      case MessageStatus.sending:
        iconData = Icons.watch_later_outlined;
        // CHANGE: Use withOpacity instead of withValues
        iconColor = isForImage
            ? Colors.white
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7);
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        iconColor = isForImage ? Colors.white : theme.colorScheme.primary;
        break;
      case MessageStatus.failed:
        iconData = Icons.error_outline;
        iconColor = isForImage ? Colors.white : theme.colorScheme.error;
        break;
    }

    final icon = Icon(iconData, size: isForImage ? 14 : 16, color: iconColor);

    if (isForImage) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: icon,
      );
    }

    return icon;
  }
}

class _StatusMessageBubble extends StatelessWidget {
  final String text;
  final Sender from;
  final Rx<MessageStatus> status;

  const _StatusMessageBubble({
    required this.text,
    required this.from,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble(text: text, from: from);

    if (from != Sender.user) {
      return bubble;
    }

    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          bubble,
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: _MessageStatusIcon(status: status.value),
          ),
        ],
      );
    });
  }
}
