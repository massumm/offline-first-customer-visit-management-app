import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/onboarding_qa_model.dart';
import 'message_status_icon.dart';

class StatusImageBubble extends StatelessWidget {
  final String imagePath;
  final Sender from;
  final Rx<MessageStatus> status;

  const StatusImageBubble({
    super.key,
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
                    child: MessageStatusIcon(
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
