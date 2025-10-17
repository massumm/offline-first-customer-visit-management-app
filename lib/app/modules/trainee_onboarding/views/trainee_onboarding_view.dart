import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';

import '../../icon_chat/views/icon_chat_view.dart';
import '../controllers/trainee_onboarding_controller.dart';
import '../models/onboarding_qa_model.dart';
import 'widgets/message_bubble.dart';
import 'widgets/type_bubble.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  TraineeOnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: CustomAppBar(),
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
          if (q == null || q.type != QAType.choice) {
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
            final isChoice = controller.isCurrentChoice;

            // When the current question is a date type, show a date picker button.
            if (controller.isCurrentDate) {
              return ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)), // Sensible default
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