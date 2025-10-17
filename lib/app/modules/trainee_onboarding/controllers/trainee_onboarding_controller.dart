import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    // --------- GOALS ----------
    QuestionGroup(
      introduction: "Let's set some goals. What are you aiming for?",
      questions: [
        const QAItem(
          id: 'fitness_goals',
          question: "What are your fitness goals right now?",
          type: QAType.text,
          hint: "e.g., Lose 10 lbs, run a 5k",
        ),
        const QAItem(
          id: 'results_speed',
          question: "How fast would you like to achieve results?",
          type: QAType.choice,
          options: [
            "Gradual",
            "Moderate",
            "Fast",
            "Not sure yet",
          ],
        ),
        // 1. This is the new branching question
        const QAItem(
          id: 'has_target_event',
          question: "Do you have a specific date or event you’re working toward?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        // This question is asked only if the answer above is "Yes"
        const QAItem(
          id: 'target_event_name',
          question: "What's the name of the event?",
          type: QAType.text,
          hint: "e.g., Wedding, Marathon",
        ),
        // This question is also asked only if the answer is "Yes"
        const QAItem(
          id: 'target_event_date',
          question: "And when is it?",
          type: QAType.date,
          hint: "Select the event date",
        ),
        const QAItem(
          id: 'success_in_6_months',
          question: "What would success look like for you in 6 months?",
          type: QAType.text,
          hint: "Optional: e.g., More energy, feel stronger",
          canSkip: true,
        ),
      ],
    ),
    //-------- ACTIVITY ---------
    QuestionGroup(
      introduction: "Now, let's get into your activity habits.",
      questions: [
        const QAItem(
          id: 'training_location',
          question: "Where do you usually train?",
          type: QAType.choice,
          options: ["At a gym", "At home", "Outdoors", "A mix", "Prefer not to say"],
        ),
        // This question is asked only if the answer above is "At home" or "A mix"
        const QAItem(
          id: 'home_equipment',
          question: "What equipment do you have access to at home?",
          type: QAType.choice,
          options: ['None', 'Weights', 'Barbell', 'Bands' 'Cardio equipment', 'Both', 'Other'],
        ),
        // This new question is asked only if the answer above is "Other"
        const QAItem(
          id: 'home_equipment_other',
          question: "Please specify what 'Other' equipment you have.",
          type: QAType.text,
          hint: "e.g., Kettlebells, TRX",
          canSkip: true,
        ),
        const QAItem(
          id: 'training_style',
          question: "What is your preferred training style?",
          type: QAType.choice,
          options: [
            "Strength training",
            "Cardio",
            "HIIT",
            "Yoga/Pilates",
            "A mix",
            "Not sure yet"
            'Other'
          ],
        ),
        // New conditional question added here
        const QAItem(
          id: 'training_style_other',
          question: "Please specify your preferred training style.",
          type: QAType.text,
          hint: "e.g., CrossFit, Calisthenics",
          canSkip: true,
        ),
        const QAItem(
          id: 'workout_frequency',
          question: "How many days a week do you plan to work out?",
          type: QAType.choice,
          options: ["1-2", "3-4", "5+", "Not sure yet"],
        ),
        const QAItem(
          id: 'session_duration',
          question: "How long would you like your sessions to be?",
          type: QAType.choice,
          options: [
            "15-30 minutes",
            "30-45 minutes",
            "45-60 minutes",
            "60+ minutes",
            "Varies / Not sure"
          ],
        ),
        const QAItem(
          id: 'session_intensity',
          question: "How intense would you like your sessions to be?",
          type: QAType.choice,
          options: ["Light", "Moderate", "Intense", "Varies / Not sure"],
        ),
        const QAItem(
          id: 'preferred_training_time',
          question: "What time of day do you prefer to train?",
          type: QAType.choice,
          options: [
            "Morning (before 9 AM)",
            "Late Morning (9 AM - 12 PM)",
            "Afternoon (12 PM - 5 PM)",
            "Evening (after 5 PM)",
            "Anytime / Varies",
            "Prefer not to say",
          ],
        ),
        // New question: Asks to set a reminder if a specific time was chosen
        const QAItem(
          id: 'set_reminder',
          question: "Would you like to set a reminder for your selected time?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        // New question: Asks for the time if the answer above was "Yes"
        const QAItem(
          id: 'reminder_time',
          question: "Great! At what time would you like to be reminded?",
          type: QAType.time, // Assumes a new QAType.time for a time picker
          hint: "Select a time",
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
    int nextQuestionIndex = currentQuestionIndexInGroup.value;
    int nextGroupIndex = currentGroupIndex.value;

    // Loop to find the next valid, non-skipped question
    while (true) {
      nextQuestionIndex++;

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

      final questionCandidate =
      questionGroups[nextGroupIndex].questions[nextQuestionIndex];

      // --- Centralized Branching Logic ---
      bool shouldSkip = false;

      // Rule 1: Skip event questions if user answered "No"
      if ((questionCandidate.id == 'target_event_name' ||
          questionCandidate.id == 'target_event_date') &&
          answers['has_target_event'] == 'No') {
        shouldSkip = true;
      }

      // Rule 2: Skip home equipment questions if not training at home/mix
      final trainingLocation = answers['training_location'];
      if ((questionCandidate.id == 'home_equipment' ||
          questionCandidate.id == 'home_equipment_other') &&
          (trainingLocation != 'At home' && trainingLocation != 'A mix')) {
        shouldSkip = true;
      }

      // Rule 3: Skip 'other' equipment detail if user didn't select 'Other'
      if (questionCandidate.id == 'home_equipment_other' &&
          answers['home_equipment'] != 'Other') {
        shouldSkip = true;
      }

      // Rule 4: Skip 'other' training style if user didn't select 'Other'
      if (questionCandidate.id == 'training_style_other' &&
          answers['training_style'] != 'Other') {
        shouldSkip = true;
      }

      // Rule 5: Skip reminder questions if no specific time was chosen.
      final preferredTime = answers['preferred_training_time'];
      if ((questionCandidate.id == 'set_reminder' ||
          questionCandidate.id == 'reminder_time') &&
          (preferredTime == 'Anytime / Varies' ||
              preferredTime == 'Prefer not to say')) {
        shouldSkip = true;
      }

      // Rule 6: Skip reminder time picker if user answered "No".
      if (questionCandidate.id == 'reminder_time' &&
          answers['set_reminder'] == 'No') {
        shouldSkip = true;
      }


      if (!shouldSkip) {
        // Found a valid question, break the loop
        break;
      }
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

    // The new _askNext() method now handles all branching logic,
    // so the special cases are no longer needed here.
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

    int targetQuestionIndex = currentQuestionIndexInGroup.value;
    int targetGroupIndex = currentGroupIndex.value;

    // This loop finds the correct previous question to go back to,
    // automatically handling branches that were skipped.
    while (true) {
      targetQuestionIndex--;

      if (targetQuestionIndex < 0) {
        targetGroupIndex--;
        targetQuestionIndex =
            questionGroups[targetGroupIndex].questions.length - 1;
      }

      final questionCandidate =
      questionGroups[targetGroupIndex].questions[targetQuestionIndex];

      // Check if this candidate question should have been skipped based on previous answers.
      bool wasSkipped = false;
      // Rule 1
      if ((questionCandidate.id == 'target_event_name' ||
          questionCandidate.id == 'target_event_date') &&
          answers['has_target_event'] == 'No') {
        wasSkipped = true;
      }

      // Rule 2
      final trainingLocation = answers['training_location'];
      if ((questionCandidate.id == 'home_equipment' ||
          questionCandidate.id == 'home_equipment_other') &&
          (trainingLocation != 'At home' && trainingLocation != 'A mix')) {
        wasSkipped = true;
      }

      // Rule 3
      if (questionCandidate.id == 'home_equipment_other' &&
          answers['home_equipment'] != 'Other') {
        wasSkipped = true;
      }

      // Rule 4
      if (questionCandidate.id == 'training_style_other' &&
          answers['training_style'] != 'Other') {
        wasSkipped = true;
      }


      // Rule 5
      final preferredTime = answers['preferred_training_time'];
      if ((questionCandidate.id == 'set_reminder' ||
          questionCandidate.id == 'reminder_time') &&
          (preferredTime == 'Anytime / Varies' ||
              preferredTime == 'Prefer not to say')) {
        wasSkipped = true;
      }

      // Rule 6
      if (questionCandidate.id == 'reminder_time' &&
          answers['set_reminder'] == 'No') {
        wasSkipped = true;
      }

      if (!wasSkipped) {
        // This is a valid previous question, so we break the loop.
        break;
      }
    }

    final q = questionGroups[targetGroupIndex].questions[targetQuestionIndex];
    await _botSay(q.question);

    // Update state to the new, correct previous position.
    currentGroupIndex.value = targetGroupIndex;
    currentQuestionIndexInGroup.value = targetQuestionIndex;
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


  Future<void> selectTime(TimeOfDay time, BuildContext context) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    final formattedTime = time.format(context);

    _saveUserAnswer(q, formattedTime);
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

  bool get isCurrentTime => currentQuestion?.type == QAType.time;
}