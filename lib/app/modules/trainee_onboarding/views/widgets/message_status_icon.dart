import 'package:flutter/material.dart';

import '../../models/onboarding_qa_model.dart';

class MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;
  final bool isForImage;

  const MessageStatusIcon({super.key, required this.status, this.isForImage = false});

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
