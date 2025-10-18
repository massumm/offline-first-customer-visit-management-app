import 'package:flutter/material.dart';

import '../../models/onboarding_qa_model.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final Sender from;

  const MessageBubble({super.key, required this.text, required this.from});

  @override
  Widget build(BuildContext context) {
    final isUser = from == Sender.user;
    final bg = isUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final fg = isUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(isUser ? 14 : 2),
          bottomRight: Radius.circular(isUser ? 2 : 14),
        ),
      ),
      child: Text(text, style: TextStyle(color: fg, fontSize: 15)),
    );
  }
}