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
      id: 'dob',
      question: "Nice to meet you. What's your date of birth?",
      type: QAType.date,
      hint: "Select your date of birth",
    ),
    const QAItem(
      id: 'gender',
      question: "What is your gender?",
      type: QAType.choice,
      options: ["Male", "Female", "Prefer not to say"],
    ),
    const QAItem(
      id: 'address',
      question: "Where are you located?",
      type: QAType.text,
      hint: "e.g., New York, USA",
    ),
    const QAItem(
      id: 'fitness_experience',
      question: "What's your current fitness experience level?",
      type: QAType.choice,
      options: ["Beginner", "Intermediate", "Advanced", "Prefer not to say"],
    ),
    const QAItem(
      id: 'accountability_partner',
      question:
      "Do you have an accountability partner - somebody to help you with your fitness journey?",
      type: QAType.choice,
      options: [
        "Friends",
        "Family",
        'Personal trainer',
        "Prefer not to say",
        'None',
      ],
    ),
    const QAItem(
      id: 'fitness_motivation',
      question: "Why do you want to improve your fitness right now?",
      type: QAType.text,
      hint: "Optional: Press send to skip",
      canSkip: true,
    ),
    const QAItem(
      id: 'fitness_inspiration',
      question: "Who inspires you the most in your fitness journey?",
      type: QAType.text,
      hint: "Optional: Press send to skip",
      canSkip: true,
    ),


    // const QAItem(
    //   id: 'role',
    //   question: "What are you working as?",
    //   type: QAType.choice,
    //   options: ["Student", "Engineer", "Designer", "Manager", "Other"],
    // ),
    // const QAItem(
    //   id: 'goal',
    //   question:
    //       "What do you want this app to help you with? (one line is fine)",
    //   type: QAType.text,
    //   hint: "e.g., manage tasks, track habits, etc.",
    // ),
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
    // Check if we are at the end of the onboarding flow.
    if (currentIndex.value + 1 >= questions.length) {
      currentIndex.value = questions.length; // Set to "done" state.
      await _botSay("All set! 🎉 Thanks for the info.");
      final summary =
      answers.entries.map((e) => "• ${e.key}: ${e.value}").join("\n");
      // Make the summary message more user-friendly
      await _botSay("Here's a summary of your answers:\n$summary");
      await _botSay("You can now proceed, or use the ↺ button to restart.");
      return;
    }

    // Get the next question without updating the public state yet.
    final nextIndex = currentIndex.value + 1;
    final q = questions[nextIndex];

    // The bot "types" and sends the question first.
    await _botSay(q.question);

    // Now, after the bot has "spoken", update the current index.
    // This will trigger the UI to show the new input controls (e.g., quick replies).
    currentIndex.value = nextIndex;
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
    final value = text.trim();

    // If flow is finished, any input restarts it.
    if (currentIndex.value >= questions.length) {
      messages.add(ChatMessage(from: Sender.user, text: value));
      _scrollToBottom();
      start();
      return;
    }

    if (!_canAnswer) return;

    final q = questions[currentIndex.value];

    // Handle empty input
    if (value.isEmpty) {
      // Allow skipping for the optional motivation question
      if (q.canSkip) {
        _saveUserAnswer(q, "Skipped");
        inputText.value = '';
        await _askNext();
      }
      // For all other required questions, do nothing on empty input.
      return;
    }

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

    // Announce the action first for a smoother experience.
    await _botSay("No problem—let's change that.");

    // Get the previous question's info without updating the public state.
    final prevIndex = currentIndex.value - 1;
    final q = questions[prevIndex];

    // Ask the previous question again.
    await _botSay(q.question);

    // Now update the index to show the correct input controls.
    currentIndex.value = prevIndex;
  }

  /// For exporting, consider sending this map to your backend.
  Map<String, dynamic> toJson() => {
    'answers': answers,
    'completed': currentIndex.value >= questions.length,
    'timestamp': DateTime.now().toIso8601String(),
  };

  /// Handle date selection from a picker
  Future<void> selectDate(DateTime date) async {
    if (!_canAnswer) return;
    final q = questions[currentIndex.value];

    // Format the date for storage and display (e.g., YYYY-MM-DD)
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    _saveUserAnswer(q, formattedDate);
    await _askNext();
  }

  // Helpers for cleaner Obx use
  QAItem? get currentQuestion =>
      (currentIndex.value >= 0 && currentIndex.value < questions.length)
          ? questions[currentIndex.value]
          : null;

  bool get isCurrentChoice => currentQuestion?.type == QAType.choice;

  bool get isCurrentDate => currentQuestion?.type == QAType.date;
}