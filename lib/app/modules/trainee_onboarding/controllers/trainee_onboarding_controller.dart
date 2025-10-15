import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

import '../models/onboarding_qa_model.dart';

class TraineeOnboardingController extends BaseController {
  final textController = TextEditingController();

  /// Configure your flow here
  final questions = <QAItem>[
    const QAItem(
      id: 'name',
      question: "Hey! What's your name?",
      type: QAType.text,
      hint: "Type your name",
    ),
    const QAItem(
      id: 'age',
      question: "Nice to meet you. How old are you?",
      type: QAType.number,
      hint: "Enter a number",
    ),
    const QAItem(
      id: 'role',
      question: "What are you working as?",
      type: QAType.choice,
      options: ["Student", "Engineer", "Designer", "Manager", "Other"],
    ),
    const QAItem(
      id: 'goal',
      question:
      "What do you want this app to help you with? (one line is fine)",
      type: QAType.text,
      hint: "e.g., manage tasks, track habits, etc.",
    ),
  ];

  /// Reactive state
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final inputText = ''.obs;
  final currentIndex = (-1).obs; // <--- reactive now
  final Map<String, String> answers = {}; // id -> answer
  final pageController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    start();
  }

  void start() async {
    messages.clear();
    answers.clear();
    currentIndex.value = -1;
    await _botSay("Hello 👋");
    await _askNext();
  }

  Future<void> _botSay(String text) async {
    isTyping.value = true;
    final delayMs = (text.length * 25).clamp(400, 1500);
    await Future.delayed(Duration(milliseconds: delayMs));
    messages.add(ChatMessage(from: Sender.bot, text: text));
    isTyping.value = false;
    _scrollToBottom();
  }

  Future<void> _askNext() async {
    if (currentIndex.value + 1 >= questions.length) {
      currentIndex.value = questions.length; // “done”
      await _botSay("All set! 🎉 Thanks for the info.");
      final summary = answers.entries
          .map((e) => "• ${e.key}: ${e.value}")
          .join("\n");
      await _botSay("Summary:\n$summary");
      await _botSay("Type anything to restart, or use the ↺ button.");
      return;
    }
    currentIndex.value++;
    final q = questions[currentIndex.value];
    await _botSay(q.question);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.animateTo(
          pageController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Handle quick replies (choices)
  Future<void> choose(String option) async {
    if (!_canAnswer) return;
    final q = questions[currentIndex.value];
    _saveUserAnswer(q, option);
    await _askNext();
  }

  /// Handle send from text field
  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;

    // If finished, restart
    if (currentIndex.value >= questions.length) {
      messages.add(ChatMessage(from: Sender.user, text: text.trim()));
      _scrollToBottom();
      start();
      return;
    }

    if (!_canAnswer) return;

    final q = questions[currentIndex.value];
    final value = text.trim();

    // Simple validation by type
    if (q.type == QAType.number && int.tryParse(value) == null) {
      await _botSay("Please enter a valid number 🔢");
      return;
    }

    _saveUserAnswer(q, value);
    inputText.value = '';
    await _askNext();
  }

  bool get _canAnswer =>
      currentIndex.value >= 0 &&
          currentIndex.value < questions.length &&
          !isTyping.value;

  void _saveUserAnswer(QAItem q, String value) {
    messages.add(ChatMessage(from: Sender.user, text: value));
    answers[q.id] = value;
    _scrollToBottom();
  }

  bool get canGoBack =>
      currentIndex.value > 0 && currentIndex.value < questions.length;

  /// Go back one step (keeps prior answers)
  Future<void> goBack() async {
    if (!canGoBack) return;
    currentIndex.value--;
    await _botSay("No problem—let's change that.");
    final q = questions[currentIndex.value];
    await _botSay(q.question);
  }

  /// For exporting, consider sending this map to your backend.
  Map<String, dynamic> toJson() => {
    'answers': answers,
    'completed': currentIndex.value >= questions.length,
    'timestamp': DateTime.now().toIso8601String(),
  };

  // Helpers for cleaner Obx use
  QAItem? get currentQuestion =>
      (currentIndex.value >= 0 && currentIndex.value < questions.length)
          ? questions[currentIndex.value]
          : null;

  bool get isCurrentChoice => currentQuestion?.type == QAType.choice;
}


//