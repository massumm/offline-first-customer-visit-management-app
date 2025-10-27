enum QAType { text, number, choice, date, time, height, weight, image }

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
  final String id;
  final String question;
  final QAType type;
  final List<String> options; // used for choice type
  final String? hint;
  final bool canSkip;

  const QAItem({
    required this.id,
    required this.question,
    required this.type,
    this.options = const [],
    this.hint,
    this.canSkip = false,
  });
}

enum Sender { bot, user }

class ChatMessage {
  final Sender from;
  final String text;
  final String? imagePath;
  final DateTime at;

  ChatMessage({required this.from, required this.text, this.imagePath, DateTime? at})
    : at = at ?? DateTime.now();
}
