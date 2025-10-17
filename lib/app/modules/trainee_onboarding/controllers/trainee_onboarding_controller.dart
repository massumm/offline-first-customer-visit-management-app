import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

import '../models/onboarding_qa_model.dart';


class TraineeOnboardingController extends BaseController {
  final textController = TextEditingController();

  /// Configure your flow here
  final questionGroups = <QuestionGroup>[
    QuestionGroup(
      introduction: "To start, let's get some personal details.",
      questions: [
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
      ],
    ),
    QuestionGroup(
      introduction: "Great! Now for a bit about your fitness background.",
      questions: [
        const QAItem(
          id: 'fitness_experience',
          question: "What's your current fitness experience level?",
          type: QAType.choice,
          options: ["Beginner", "Intermediate", "Advanced", "Prefer not to say"],
        ),
        const QAItem(
          id: 'accountability_partner',
          question:
          "Do you have an accountability partner to help you on your journey?",
          type: QAType.choice,
          options: [
            "Friends",
            "Family",
            'Personal trainer',
            "Prefer not to say",
            'None',
          ],
        ),
      ],
    ),
    QuestionGroup(
      introduction: "Let's set some goals. What are you aiming for?",
      questions: [
        const QAItem(
          id: 'fitness_goals',
          question: "What are your fitness goals right now?",
          type: QAType.text,
          hint: "e.g., Lose 10 lbs, run a 5k",
        ),
      ],
    ),
    QuestionGroup(
      introduction: "Finally, let's talk about what drives you.",
      questions: [
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
      ],
    ),
  ];

  /// Reactive state
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final inputText = ''.obs;
  // Replace currentIndex with group and question indices
  final currentGroupIndex = 0.obs;
  final currentQuestionIndexInGroup = (-1).obs;
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
    currentGroupIndex.value = 0;
    currentQuestionIndexInGroup.value = -1; // Start before the first question
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
    // Determine the next position
    int nextQuestionIndex = currentQuestionIndexInGroup.value + 1;
    int nextGroupIndex = currentGroupIndex.value;

    // Check if we need to advance to the next group
    if (nextGroupIndex < questionGroups.length &&
        nextQuestionIndex >= questionGroups[nextGroupIndex].questions.length) {
      nextGroupIndex++;
      nextQuestionIndex = 0;
    }

    // Check if the entire flow is finished
    if (nextGroupIndex >= questionGroups.length) {
      currentGroupIndex.value = questionGroups.length; // Set to "done" state
      await _botSay("All set! 🎉 Thanks for the info.");
      final summary =
      answers.entries.map((e) => "• ${e.key}: ${e.value}").join("\n");
      await _botSay("Here's a summary of your answers:\n$summary");
      await _botSay("You can now proceed, or use the ↺ button to restart.");
      return;
    }

    // If we are starting a new group, show its introduction message
    final bool isNewGroup = nextQuestionIndex == 0 &&
        (currentGroupIndex.value != nextGroupIndex ||
            currentQuestionIndexInGroup.value == -1);

    if (isNewGroup) {
      await _botSay(questionGroups[nextGroupIndex].introduction);
    }

    // Ask the actual question
    final q = questionGroups[nextGroupIndex].questions[nextQuestionIndex];
    await _botSay(q.question);

    // Update the state to the new position
    currentGroupIndex.value = nextGroupIndex;
    currentQuestionIndexInGroup.value = nextQuestionIndex;
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
    final q = currentQuestion!;
    _saveUserAnswer(q, option);
    await _askNext();
  }

  /// Handle send from text field
  Future<void> send(String text) async {
    final value = text.trim();

    // If flow is finished, any input restarts it.
    if (isFinished) {
      messages.add(ChatMessage(from: Sender.user, text: value));
      _scrollToBottom();
      start();
      return;
    }

    if (!_canAnswer) return;

    final q = currentQuestion!;

    // ... (rest of the send method is the same)
    if (value.isEmpty) {
      if (q.canSkip) {
        _saveUserAnswer(q, "Skipped");
        inputText.value = '';
        await _askNext();
      }
      return;
    }

    if (q.type == QAType.number && int.tryParse(value) == null) {
      await _botSay("Please enter a valid number 🔢");
      return;
    }

    _saveUserAnswer(q, value);
    inputText.value = '';
    await _askNext();
  }

  // --- Updated Helper Getters and Methods ---

  bool get isFinished => currentGroupIndex.value >= questionGroups.length;

  bool get _canAnswer =>
      !isFinished &&
          !isTyping.value &&
          currentQuestionIndexInGroup.value != -1;

  void _saveUserAnswer(QAItem q, String value) {
    messages.add(ChatMessage(from: Sender.user, text: value));
    answers[q.id] = value;
    _scrollToBottom();
  }

  bool get canGoBack =>
      !isFinished &&
          (currentGroupIndex.value > 0 || currentQuestionIndexInGroup.value > 0);

  /// Go back one step (keeps prior answers)
  Future<void> goBack() async {
    if (!canGoBack) return;

    await _botSay("No problem—let's change that.");

    int prevQuestionIndex = currentQuestionIndexInGroup.value - 1;
    int prevGroupIndex = currentGroupIndex.value;

    // If we are at the beginning of a group, go to the end of the previous one
    if (prevQuestionIndex < 0) {
      prevGroupIndex--;
      prevQuestionIndex = questionGroups[prevGroupIndex].questions.length - 1;
    }

    final q = questionGroups[prevGroupIndex].questions[prevQuestionIndex];
    await _botSay(q.question);

    // Update state to the previous position
    currentGroupIndex.value = prevGroupIndex;
    currentQuestionIndexInGroup.value = prevQuestionIndex;
  }

  Map<String, dynamic> toJson() => {
    'answers': answers,
    'completed': isFinished,
    'timestamp': DateTime.now().toIso8601String(),
  };

  Future<void> selectDate(DateTime date) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    // ... (rest of the method is the same)
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    _saveUserAnswer(q, formattedDate);
    await _askNext();
  }

  // Helpers for cleaner Obx use
  QAItem? get currentQuestion {
    if (isFinished || currentQuestionIndexInGroup.value < 0) {
      return null;
    }
    return questionGroups[currentGroupIndex.value]
        .questions[currentQuestionIndexInGroup.value];
  }

  bool get isCurrentChoice => currentQuestion?.type == QAType.choice;

  bool get isCurrentDate => currentQuestion?.type == QAType.date;
}