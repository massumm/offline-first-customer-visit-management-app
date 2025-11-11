import 'package:get/get.dart';

import 'trainee_onboarding_questions_model.dart';

class QuestionGroup {
  final String name;
  final String introduction;
  final String? conclusion;
  final List<QAItem> questions;

  const QuestionGroup({
    required this.name,
    required this.introduction,
    this.conclusion,
    required this.questions,
  });
}

class QAItem {
  final int id;
  final String question;
  final QuestionType type;
  final String? hint;
  final bool canSkip;
  final String? questionFieldName;
  final QuestionMetadata? metadata;

  const QAItem({
    required this.id,
    required this.question,
    required this.type,
    required this.questionFieldName,
    this.metadata,
    this.hint,
    this.canSkip = false,
  });
}

enum Sender { bot, user }

enum MessageStatus { pending, sending, delivered, failed }

class ChatMessage {
  final Sender from;
  final String text;
  final String? imagePath;

  // final DateTime at;
  final Rx<MessageStatus> status;

  ChatMessage({
    required this.from,
    required this.text,
    this.imagePath,
    MessageStatus status = MessageStatus.pending,
  }) : status = status.obs;

  void updateStatus(MessageStatus newStatus) {
    status.value = newStatus;
  }
}
