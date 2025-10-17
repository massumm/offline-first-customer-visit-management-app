import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';

import '../controllers/trainee_onboarding_controller.dart';
import '../models/onboarding_qa_model.dart';
import 'widgets/message_bubble.dart';
import 'widgets/type_bubble.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  TraineeOnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Onboarding Assistant'),
      centerTitle: true,
      actions: [
        Obx(
          () => controller.canGoBack
              ? IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: controller.goBack,
                  tooltip: 'Go Back',
                )
              : const SizedBox.shrink(),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: controller.start,
          tooltip: 'Restart',
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
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
                return Align(
                  alignment: m.from == Sender.user
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: MessageBubble(text: m.text, from: m.from),
                );
              },
            );
          }),
        ),

        /// Quick replies (only for choice-type question)
        Obx(() {
          final q = controller.currentQuestion;
          // Hide quick replies if the flow is finished, paused, or not a choice question.
          if (controller.isFinished ||
          controller.showGroupContinuationButtons ||
          q == null ||
          q.type != QAType.choice) {
          // END: Modify this condition
          return const SizedBox.shrink();
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: q.options
                  .map(
                    (o) => ActionChip(
                  label: Text(o),
                  onPressed: () => controller.choose(o),
                ),
              )
                  .toList(),
            ),
          );
        }),

        // Input
        SafeArea(
          top: false,
          child: Obx(() {
            // When a group is finished, show Continue/Skip buttons.
            if (controller.showGroupContinuationButtons) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: controller.continueToNextGroup,
                        child: const Text('Continue'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.skipToEnd,
                        child: const Text('Skip to End'),
                      ),
                    ),
                  ],
                ),
              );
            }

            final isChoice = controller.isCurrentChoice;

            // When the current question is a date type, show a date picker button.
            if (controller.isCurrentDate) {
              return ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 365 * 20),
                    ), // Sensible default
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    controller.selectDate(pickedDate);
                  }
                },
                child: Text(controller.currentQuestion?.hint ?? "Select Date"),
              );
            }

            // When the current question is a time type, show a time picker button.
            if (controller.isCurrentTime) {
              return ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    controller.selectTime(pickedTime, context);
                  }
                },
                child: Text(controller.currentQuestion?.hint ?? "Select Time"),
              );
            }

            // Default input field for text/number questions.
            return Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: IgnorePointer(
                    ignoring: isChoice,
                    child: TextField(
                      controller: controller.textController,
                      onChanged: (t) => controller.inputText.value = t,
                      onSubmitted: (t) {
                        controller.send(t);
                        controller.textController.clear();
                      },
                      decoration: InputDecoration(
                        hintText: _hintFor(),
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    controller.send(controller.textController.text);
                    controller.textController.clear();
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Send"),
                ),
                const SizedBox(width: 8),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _hintFor() {
    if (controller.isFinished) {
      return "Type anything to restart";
    }
    final q = controller.currentQuestion;
    if (q == null) {
      return "Say hi to start";
    }
    if (q.type == QAType.choice) {
      return "Choose an option above";
    }
    return q.hint ?? "Type your answer";
  }
}
