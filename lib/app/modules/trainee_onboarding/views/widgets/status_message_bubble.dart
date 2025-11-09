import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/onboarding_qa_model.dart';
import 'message_bubble.dart';
import 'message_status_icon.dart';

class StatusMessageBubble extends StatelessWidget {
  final String text;
  final Sender from;
  final Rx<MessageStatus> status;

  const StatusMessageBubble({super.key,
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
            child: MessageStatusIcon(status: status.value),
          ),
        ],
      );
    });
  }
}