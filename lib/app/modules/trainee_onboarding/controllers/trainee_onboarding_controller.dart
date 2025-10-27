import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/local/preference/store/trainee_data_store.dart';
import '../../../routes/app_pages.dart';
import '../models/onboarding_qa_model.dart';

class TraineeOnboardingController extends BaseController {
  final textController = TextEditingController();

  /// Configure your flow here
  final questionGroups = <QuestionGroup>[
    QuestionGroup(
      name: 'Personal Details',
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
      name: 'Fitness Background',
      introduction: "Great! Now for a bit about your fitness background.",
      questions: [
        const QAItem(
          id: 'fitness_experience',
          question: "What's your current fitness experience level?",
          type: QAType.choice,
          options: [
            "Beginner",
            "Intermediate",
            "Advanced",
            "Prefer not to say",
          ],
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
      name: 'Goals',
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
          options: ["Gradual", "Moderate", "Fast", "Not sure yet"],
        ),
        const QAItem(
          id: 'has_target_event',
          question:
          "Do you have a specific date or event you’re working toward?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        const QAItem(
          id: 'target_event_name',
          question: "What's the name of the event?",
          type: QAType.text,
          hint: "e.g., Wedding, Marathon",
        ),
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
      name: 'Activity',
      introduction: "Now, let's get into your activity habits.",
      conclusion:
      "Awesome, that gives me a great picture of your activity levels!",
      questions: [
        const QAItem(
          id: 'training_location',
          question: "Where do you usually train?",
          type: QAType.choice,
          options: [
            "At a gym",
            "At home",
            "Outdoors",
            "A mix",
            "Prefer not to say",
          ],
        ),
        const QAItem(
          id: 'home_equipment',
          question: "What equipment do you have access to at home?",
          type: QAType.choice,
          options: [
            'None',
            'Weights',
            'Barbell',
            'Bands',
            'Cardio equipment',
            'Both',
            'Other',
          ],
        ),
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
            "Not sure yet",
            'Other',
          ],
        ),
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
            "Varies / Not sure",
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
        const QAItem(
          id: 'set_reminder',
          question: "Would you like to set a reminder for your selected time?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        const QAItem(
          id: 'reminder_time',
          question: "Great! At what time would you like to be reminded?",
          type: QAType.time,
          hint: "Select a time",
        ),
        const QAItem(
          id: 'focus_on_body_parts',
          question: "Are there any specific body parts you want to focus on?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        const QAItem(
          id: 'specific_body_parts',
          question: "Great! Which body parts are your priority?",
          type: QAType.text,
          hint: "e.g., Chest, Legs, Abs",
        ),
        const QAItem(
          id: 'occupation_activity_level',
          question: "Outside of training, how active is your occupation?",
          type: QAType.choice,
          options: [
            "Mostly sedentary (desk job)",
            "Lightly active (some walking)",
            "Moderately active (on your feet)",
            "Very active (manual labor)",
          ],
        ),
        const QAItem(
          id: 'general_lifestyle_activity',
          question:
          "Outside of training and your occupation, how active is your general lifestyle?",
          type: QAType.choice,
          options: [
            "Mostly sedentary (e.g., relaxing at home)",
            "Lightly active (e.g., occasional walks, light chores)",
            "Moderately active (e.g., regular walks, hobbies)",
            "Very active (e.g., always on the go, active hobbies)",
          ],
        ),
        const QAItem(
          id: 'daily_step_goal',
          question: "How many steps would you like to achieve each day?",
          type: QAType.choice,
          options: [
            "5,000",
            "8,000",
            "10,000",
            "12,000+",
            'Custom number',
            "Not sure yet",
          ],
        ),
        const QAItem(
          id: 'daily_step_goal_custom',
          question: "What is your custom daily step goal?",
          type: QAType.number,
          hint: "e.g., 7500",
        ),
        const QAItem(
          id: 'training_limitations',
          question: "What limits your ability to train consistently?",
          type: QAType.choice,
          options: [
            "Lack of time",
            "Lack of motivation",
            "Low energy levels",
            "Access to gym/equipment",
            "Not sure what to do",
            "Nothing really",
            "Other",
          ],
        ),
        const QAItem(
          id: 'training_limitations_other',
          question:
          "Could you please specify what other factors limit your training?",
          type: QAType.text,
          hint: "e.g., Injury, travel schedule",
          canSkip: true,
        ),
        const QAItem(
          id: 'workout_enjoyment',
          question:
          "What kind of workouts do you most enjoy, or is there anything you want to try?",
          type: QAType.text,
          hint: "e.g., Running, weightlifting, dance classes",
          canSkip: true,
        ),
      ],
    ),
    // ---------- Recovery ----------
    QuestionGroup(
      name: 'Recovery',
      introduction: "Finally, let's talk about recovery.",
      conclusion: "That's everything I need to know. Thanks for sharing!",
      questions: [
        const QAItem(
          id: 'sleep_hours',
          question: "On average, how many hours of sleep do you get per night?",
          type: QAType.choice,
          options: [
            "Less than 5 hours",
            "5-6 hours",
            "7-8 hours",
            "More than 8 hours",
            "It varies a lot",
          ],
        ),
        const QAItem(
          id: 'sleep_quality',
          question: "How would you rate your sleep quality?",
          type: QAType.choice,
          options: ["Excellent", "Good", "Fair", "Poor", "It varies"],
        ),
        const QAItem(
          id: 'energy_levels',
          question: "How energetic do you usually feel during the day?",
          type: QAType.choice,
          options: [
            "Very energetic",
            "Moderately energetic",
            "A bit sluggish",
            "Very low energy / Fatigued",
            "It varies a lot",
          ],
        ),
        const QAItem(
          id: 'stress_levels',
          question: "How would you rate your current stress levels?",
          type: QAType.choice,
          options: ["Very low", "Low", "Moderate", "High", "Very high"],
        ),
        const QAItem(
          id: 'stress_sources',
          question: "What are your biggest sources of stress?",
          type: QAType.choice,
          options: [
            "Work / School",
            "Family / Relationships",
            "Finances",
            "Health",
            "A mix of factors",
            "Other",
            "Prefer not to say",
          ],
        ),
        const QAItem(
          id: 'stress_sources_other',
          question: "Please specify what 'Other' sources of stress you have.",
          type: QAType.text,
          hint: "Optional: e.g., Social life, personal goals",
          canSkip: true,
        ),
        const QAItem(
          id: 'has_injuries',
          question:
          "Do you have any injuries or conditions that impact your fitness?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        const QAItem(
          id: 'injury_name_1',
          question: "What is the injury or condition?",
          type: QAType.text,
          hint: "e.g., Lower back pain, Knee tendinitis",
        ),
        const QAItem(
          id: 'injury_description_1',
          question: "Please briefly describe it and any limitations it causes.",
          type: QAType.text,
          hint: "Optional: e.g., 'Can't do heavy squats'",
          canSkip: true,
        ),
        const QAItem(
          id: 'add_another_injury',
          question: "Would you like to add another injury or condition?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        const QAItem(
          id: 'injury_name_2',
          question: "What is the next injury or condition?",
          type: QAType.text,
          hint: "e.g., Shoulder impingement",
        ),
        const QAItem(
          id: 'injury_description_2',
          question: "Please briefly describe this one.",
          type: QAType.text,
          hint: "Optional",
          canSkip: true,
        ),
        const QAItem(
          id: 'recovery_obstacles',
          question:
          "What usually gets in the way of you resting and recovering properly?",
          type: QAType.choice,
          options: [
            "Busy schedule / Lack of time",
            "Stress from work/life",
            "Difficulty switching off / Relaxing",
            "Poor sleep environment",
            "Family or social obligations",
            "Nothing really",
            "Other",
          ],
        ),
        const QAItem(
          id: 'recovery_obstacles_other',
          question:
          "Please specify what other factors get in the way of your recovery.",
          type: QAType.text,
          hint: "Optional: e.g., Late-night screen time",
          canSkip: true,
        ),
      ],
    ),
    // ------------ Body Profile
    QuestionGroup(
      name: 'Body Profile',
      introduction: "Next, let's get some body profile details.",
      conclusion: "Excellent! That's all the profile information we need.",
      questions: [
        const QAItem(
          id: 'height',
          question: "What’s your height?",
          type: QAType.height,
        ),
        const QAItem(
          id: 'current_weight',
          question: "And your current weight?",
          type: QAType.weight,
        ),
        const QAItem(
          id: 'target_weight',
          question: "What is your target weight?",
          type: QAType.weight,
          hint: "Optional: You can skip this if you're not sure",
          canSkip: true,
        ),
        const QAItem(
          id: 'body_fat_level',
          question: "How would you describe your current body fat level?",
          type: QAType.choice,
          options: ["Lean", "Average", "High", "Not Sure"],
          hint: "This is just an estimate.",
        ),
        const QAItem(
          id: 'body_type',
          question: "How would you describe your body type?",
          type: QAType.choice,
          options: [
            "Ectomorph (Lean)",
            "Mesomorph (Athletic)",
            "Endomorph (Heavyset)",
            "Not Sure",
          ],
          hint: "This helps in tailoring your plan.",
        ),
        const QAItem(
          id: 'add_body_measurements',
          question: "Would you like to add any body measurements? (Optional)",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        const QAItem(
          id: 'chest_measurement',
          question: "What is your chest measurement?",
          type: QAType.weight,
          hint: "Optional: You can skip this",
          canSkip: true,
        ),
        const QAItem(
          id: 'waist_measurement',
          question: "What is your waist measurement?",
          type: QAType.weight,
          hint: "Optional: You can skip this",
          canSkip: true,
        ),
        const QAItem(
          id: 'hips_measurement',
          question: "What is your hips measurement?",
          type: QAType.weight,
          hint: "Optional: You can skip this",
          canSkip: true,
        ),
        const QAItem(
          id: 'arm_measurement',
          question: "What is your arm measurement? (e.g., bicep)",
          type: QAType.weight,
          hint: "Optional: You can skip this",
          canSkip: true,
        ),
        const QAItem(
          id: 'thigh_measurement',
          question: "What is your thigh measurement? (e.g., quad)",
          type: QAType.weight,
          hint: "Optional: You can skip this",
          canSkip: true,
        ),
        const QAItem(
          id: 'upload_progress_photo',
          question:
          "Would you like to upload a private progress photo? (Optional)",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        const QAItem(
          id: 'progress_photo_picker',
          question: "Great! Please upload your photo.",
          type: QAType.image,
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
  final isAwaitingGroupConfirmation = false.obs;
  final Map<String, String> answers = {}; // id -> answer
  final pageController = ScrollController();

  // Show the final Continue button after completion
  final isAwaitingFinalContinuation = false.obs;
  // ADD this new state variable for the checkbox
  final hasAgreedToTerms = false.obs;

  /// True when the UI should show the "Continue" and "Skip" buttons.
  bool get showGroupContinuationButtons => isAwaitingGroupConfirmation.value;

  //-------------------- QA Stepper --------------------
  final RxInt totalGroups = 0.obs;
  final RxDouble currentGroupProgress = 0.0.obs; // kept for UI that needs per-group

  @override
  void onInit() {
    super.onInit();
    totalGroups(questionGroups.length);
    // Recompute progress when position OR answers change
    currentGroupIndex.listen((_) => _updateProgresses());
    currentQuestionIndexInGroup.listen((_) => _updateProgresses());
    isAwaitingGroupConfirmation.listen((_) => _updateProgresses());
    start();
  }

  Future<void> continueToNextGroup() async {
    if (!isAwaitingGroupConfirmation.value) return;
    isAwaitingGroupConfirmation.value = false;

    currentGroupIndex.value++;
    currentQuestionIndexInGroup.value = -1;
    await _askNext();
  }

  Future<void> skipToEnd() async {
    if (!isAwaitingGroupConfirmation.value) return;
    isAwaitingGroupConfirmation.value = false;
    await _completeOnboarding();
  }

  //  toggle the agreement state from the UI
  void toggleTermsAgreement(bool? newValue) {
    hasAgreedToTerms.value = newValue ?? false;
  }


  void start() async {
    messages.clear();
    answers.clear();
    currentGroupIndex.value = 0;
    currentQuestionIndexInGroup.value = -1;
    // ADD a reset for the new state variable
    hasAgreedToTerms.value = false;
    isAwaitingFinalContinuation.value = false;
    _updateProgresses();
    await _botSay("Hello 👋");
    await _askNext();
  }

  Future<void> _completeOnboarding() async {
    currentGroupIndex.value = questionGroups.length; // done
    _updateProgresses();
    await _botSay("All set! 🎉 Thanks for the info.");
    await _botSay("Grading and storing all your information...");
    //TODO: CONFIRM
    await _botSay(
      "To save your progress and create your personalized icon profile, you'll need to agree out terms and conditions to continue.",
    );
    isAwaitingFinalContinuation.value = true;
  }

  void proceedToContinue() {
    // ADD a guard clause for safety, though the button will be disabled
    if (!hasAgreedToTerms.value) {
      CustomToast.showErrorToast(
        "Please agree to the terms and conditions to continue.",
      );
      return;
    }
    try{
      final onboardingJson = toJson();
      Get.find<TraineeDataStore>().saveOnboardingData(onboardingJson);
      CustomToast.showSuccessToast('Profile data saved successfully.');
      Get.toNamed(Routes.TRAINEE_FITNESS_REPORT_GENERATION, arguments: onboardingJson);
      "Proceeding to fitness report with data: $onboardingJson".log();
    } catch(e){
      CustomToast.showErrorToast('Error saving data: $e');
    }
  }

  Future<void> _botSay(String text) async {
    isTyping.value = true;
    final delayMs = (text.length * 25).clamp(400, 1500);
    await Future.delayed(Duration(milliseconds: delayMs));
    messages.add(ChatMessage(from: Sender.bot, text: text));
    isTyping.value = false;
    _scrollToBottom();
  }

  // -------------------- Skip rules (single source of truth) --------------------
  bool _shouldSkipQuestion(QAItem q) {
    final id = q.id;

    if ((id == 'target_event_name' || id == 'target_event_date') &&
        answers['has_target_event'] == 'No') {
      return true;
    }

    final trainingLocation = answers['training_location'];
    if ((id == 'home_equipment' || id == 'home_equipment_other') &&
        (trainingLocation != 'At home' && trainingLocation != 'A mix')) {
      return true;
    }
    if (id == 'home_equipment_other' && answers['home_equipment'] != 'Other') {
      return true;
    }

    if (id == 'training_style_other' && answers['training_style'] != 'Other') {
      return true;
    }

    final preferredTime = answers['preferred_training_time'];
    if ((id == 'set_reminder' || id == 'reminder_time') &&
        (preferredTime == 'Anytime / Varies' ||
            preferredTime == 'Prefer not to say')) {
      return true;
    }
    if (id == 'reminder_time' && answers['set_reminder'] == 'No') {
      return true;
    }

    if (id == 'specific_body_parts' && answers['focus_on_body_parts'] == 'No') {
      return true;
    }

    if (id == 'daily_step_goal_custom' &&
        answers['daily_step_goal'] != 'Custom number') {
      return true;
    }

    if (id == 'training_limitations_other' &&
        answers['training_limitations'] != 'Other') {
      return true;
    }

    if (id == 'stress_sources_other' &&
        answers['stress_sources'] != 'Other') {
      return true;
    }

    if ((id == 'injury_name_1' ||
        id == 'injury_description_1' ||
        id == 'add_another_injury' ||
        id == 'injury_name_2' ||
        id == 'injury_description_2') &&
        answers['has_injuries'] == 'No') {
      return true;
    }
    if ((id == 'injury_name_2' || id == 'injury_description_2') &&
        answers['add_another_injury'] != 'Yes') {
      return true;
    }

    if (id == 'recovery_obstacles_other' &&
        answers['recovery_obstacles'] != 'Other') {
      return true;
    }

    const measurementIds = {
      'chest_measurement',
      'waist_measurement',
      'hips_measurement',
      'arm_measurement',
      'thigh_measurement',
    };
    if (measurementIds.contains(id) &&
        answers['add_body_measurements'] != 'Yes') {
      return true;
    }

    if (id == 'progress_photo_picker' &&
        answers['upload_progress_photo'] != 'Yes') {
      return true;
    }

    return false;
  }

  // -------------------- Active/answered helpers --------------------
  List<QAItem> _activeQuestionsForGroup(int gi) {
    if (gi < 0 || gi >= questionGroups.length) return const [];
    return questionGroups[gi].questions.where((q) => !_shouldSkipQuestion(q)).toList();
  }

  int _answeredCount(Iterable<QAItem> qs) {
    int c = 0;
    for (final q in qs) {
      final v = answers[q.id];
      if (v != null && v.isNotEmpty) c++;
    }
    return c;
  }

  /// Global progress across the entire flow (0..1) based on answered, non-skipped questions.
  double _globalProgress() {
    if (questionGroups.isEmpty) return 0.0;

    int totalActive = 0;
    int totalAnswered = 0;

    for (int gi = 0; gi < questionGroups.length; gi++) {
      final activeQs = _activeQuestionsForGroup(gi);
      totalActive += activeQs.length;

      // If we've reached a group break, treat that group as fully answered
      // (you already showed summary and wait Continue/Skip).
      if (isAwaitingGroupConfirmation.value && gi < currentGroupIndex.value) {
        totalAnswered += activeQs.length;
        continue;
      }

      // normal answered count
      totalAnswered += _answeredCount(activeQs);
    }

    // End-state overrides
    if (isFinished || isAwaitingFinalContinuation.value) return 1.0;
    if (totalActive == 0) return 0.0;

    final gp = totalAnswered / totalActive;
    return gp.clamp(0.0, 1.0);
  }

  // -------------------- Core flow --------------------
  Future<void> _askNext() async {
    if (isAwaitingGroupConfirmation.value) return;

    int nextQuestionIndex = currentQuestionIndexInGroup.value;
    int nextGroupIndex = currentGroupIndex.value;

    while (true) {
      nextQuestionIndex++;

      // End of group?
      if (nextGroupIndex < questionGroups.length &&
          nextQuestionIndex >= questionGroups[nextGroupIndex].questions.length) {
        final finishedGroup = questionGroups[nextGroupIndex];

        if (finishedGroup.conclusion != null) {
          await _botSay(finishedGroup.conclusion!);
        }

        // Section summary (answered only)
        final summaryLines = <String>[];
        for (final question in finishedGroup.questions) {
          final ans = answers[question.id];
          if (ans != null && ans.isNotEmpty) {
            final qt = question.question.replaceAll('?', '');
            summaryLines.add("• $qt: **$ans**");
          }
        }
        if (summaryLines.isNotEmpty) {
          await _botSay("Here's a summary for this section:\n${summaryLines.join('\n')}");
        }

        if (nextGroupIndex >= questionGroups.length - 1) {
          await _completeOnboarding();
          return;
        }

        isAwaitingGroupConfirmation.value = true;

        final remainingGroups = questionGroups.sublist(nextGroupIndex + 1);
        final remainingGroupNames =
        remainingGroups.map((g) => "• ${g.name}").join('\n');

        await _botSay(
          "Great job! To create the best plan, we still need to cover these topics:\n$remainingGroupNames",
        );
        await _botSay("Ready to continue?");
        _updateProgresses();
        return;
      }

      if (nextGroupIndex >= questionGroups.length) {
        await _completeOnboarding();
        return;
      }

      final candidate =
      questionGroups[nextGroupIndex].questions[nextQuestionIndex];

      if (!_shouldSkipQuestion(candidate)) break;
    }

    final bool isNewGroup =
        nextQuestionIndex == 0 &&
            (currentGroupIndex.value != nextGroupIndex ||
                currentQuestionIndexInGroup.value == -1);

    if (isNewGroup) {
      await _botSay(questionGroups[nextGroupIndex].introduction);
    }

    final q = questionGroups[nextGroupIndex].questions[nextQuestionIndex];
    await _botSay(q.question);

    currentGroupIndex.value = nextGroupIndex;
    currentQuestionIndexInGroup.value = nextQuestionIndex;
    _updateProgresses();
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

    if (isFinished) {
      messages.add(ChatMessage(from: Sender.user, text: value));
      _scrollToBottom();
      start();
      return;
    }

    if (!_canAnswer) return;

    final q = currentQuestion!;

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

  // --- Helper Getters and Methods ---
  bool get isFinished => currentGroupIndex.value >= questionGroups.length;

  bool get _canAnswer =>
      !isFinished && !isTyping.value && currentQuestionIndexInGroup.value != -1;

  void _saveUserAnswer(QAItem q, String value) {
    messages.add(ChatMessage(from: Sender.user, text: value));
    answers[q.id] = value;
    _scrollToBottom();
    _updateProgresses();
  }

  bool get canGoBack =>
      !isFinished &&
          (currentGroupIndex.value > 0 || currentQuestionIndexInGroup.value > 0);

  Future<void> goBack() async {
    if (!canGoBack) return;

    await _botSay("No problem—let's change that.");

    int targetQuestionIndex = currentQuestionIndexInGroup.value;
    int targetGroupIndex = currentGroupIndex.value;

    while (true) {
      targetQuestionIndex--;

      if (targetQuestionIndex < 0) {
        targetGroupIndex--;
        targetQuestionIndex =
            questionGroups[targetGroupIndex].questions.length - 1;
      }

      final candidate =
      questionGroups[targetGroupIndex].questions[targetQuestionIndex];

      final wasSkipped = _shouldSkipQuestion(candidate);
      if (!wasSkipped) break;
    }

    final q = questionGroups[targetGroupIndex].questions[targetQuestionIndex];
    await _botSay(q.question);

    currentGroupIndex.value = targetGroupIndex;
    currentQuestionIndexInGroup.value = targetQuestionIndex;
    _updateProgresses();
  }

  Map<String, dynamic> toJson() {
    final processedAnswers = answers.map((key, value) {
      return MapEntry(key, value == 'Skipped' ? '' : value);
    });

    return {
      'answers': processedAnswers,
      'completed': isFinished,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Future<void> selectDate(DateTime date) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
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

  Future<void> selectHeight({int? cm, int? feet, int? inches}) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    String formattedHeight;

    if (cm != null) {
      formattedHeight = "$cm cm";
    } else if (feet != null && inches != null) {
      formattedHeight = "$feet' $inches\"";
    } else {
      _saveUserAnswer(q, "Skipped");
      await _askNext();
      return;
    }

    _saveUserAnswer(q, formattedHeight);
    await _askNext();
  }

  Future<void> selectWeight({double? weight, String? unit}) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    if (weight == null || unit == null) {
      _saveUserAnswer(q, "Skipped");
      await _askNext();
      return;
    }
    final formattedWeight = "${weight.toStringAsFixed(1)} $unit";
    _saveUserAnswer(q, formattedWeight);
    await _askNext();
  }

  Future<void> selectImage(XFile imageFile) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    answers[q.id] = imageFile.path;
    messages.add(
      ChatMessage(from: Sender.user, imagePath: imageFile.path, text: ''),
    );
    _scrollToBottom();
    _updateProgresses();
    await _askNext();
  }

  // -------------- Per-group progress (for section UIs) --------------
  // double _computeGroupProgress(int groupIndex) {
  //   if (groupIndex < 0 || groupIndex >= questionGroups.length) return 0.0;
  //   final activeQs = _activeQuestionsForGroup(groupIndex);
  //   if (activeQs.isEmpty) return 1.0;
  //
  //   int answered = _answeredCount(activeQs);
  //
  //   // If we’re sitting at a group break, that group is effectively complete.
  //   if (isAwaitingGroupConfirmation.value &&
  //       currentGroupIndex.value == groupIndex) {
  //     answered = activeQs.length;
  //   }
  //
  //   return (answered / activeQs.length).clamp(0.0, 1.0);
  // }

  // -------------- Stepper bindings --------------
  /// The stepper has `totalSteps` dots (groups), but the bar position should follow
  /// the **global answered fraction** of all active questions.
  // void _updateProgresses() {
  //   // keep the per-group progress if other parts of UI need it
  //   if (isFinished || currentGroupIndex.value >= questionGroups.length) {
  //     currentGroupProgress.value = 0.0;
  //   } else {
  //     currentGroupProgress.value = _computeGroupProgress(currentGroupIndex.value);
  //   }
  // }

  int get stepperTotalSteps => questionGroups.length;

  int get stepperCurrentStep {
    if (isFinished && questionGroups.isNotEmpty) {
      return questionGroups.length - 1;
    }
    return currentGroupIndex.value.clamp(
      0,
      (questionGroups.length - 1).clamp(0, 1 << 30),
    );
  }

  /// Convert global (0..1) → widget’s `(currentStep + stepProgress)/(totalSteps-1)`
  double get stepperStepProgress {
    final n = questionGroups.length;
    if (n <= 1) return _globalProgress(); // trivial bar

    // Global 0..1 fraction of answered active questions
    final gp = _globalProgress();

    // Map to overall "segment space"
    final overall = gp * (n - 1);

    // Force the thumb to live inside current step for dot visuals
    final stepProg = (overall - stepperCurrentStep).clamp(0.0, 1.0);
    return stepProg;
  }

  // ------------ Convenience flags for input UI ------------
  QAItem? get currentQuestion {
    if (isFinished || currentQuestionIndexInGroup.value < 0) return null;
    return questionGroups[currentGroupIndex.value]
        .questions[currentQuestionIndexInGroup.value];
  }

  String? get getCurrentGroupName {
    if (currentGroupIndex.value >= 0 && currentGroupIndex.value < questionGroups.length) {
      return questionGroups[currentGroupIndex.value].name;
    }
    return null;
  }

  bool get isCurrentChoice => currentQuestion?.type == QAType.choice;
  bool get isCurrentDate => currentQuestion?.type == QAType.date;
  bool get isCurrentTime => currentQuestion?.type == QAType.time;
  bool get isCurrentHeight => currentQuestion?.type == QAType.height;
  bool get isCurrentWeight => currentQuestion?.type == QAType.weight;
  bool get isCurrentImage => currentQuestion?.type == QAType.image;

  // REMOVE THIS ENTIRE METHOD
  void moveToNextGroup() {
    if (currentGroupIndex.value < totalGroups.value - 1) {
      currentGroupIndex.value++;
    }
    // This logic is incorrect for per-question progress.
    currentGroupProgress.value =
        (currentGroupIndex.value + 1) / totalGroups.value;
  }

  // -------------- Stepper bindings --------------
  /// The stepper has `totalSteps` dots (groups), but the bar position should follow
  /// the **global answered fraction** of all active questions.
  void _updateProgresses() {
    // keep the per-group progress if other parts of UI need it
    if (isFinished || currentGroupIndex.value >= questionGroups.length) {
      currentGroupProgress.value = 0.0;
    } else {
      // This is the key line that computes the progress for the current group.
      currentGroupProgress.value = _computeGroupProgress(currentGroupIndex.value);
    }
  }
  // -------------- Per-group progress (for section UIs) --------------
  double _computeGroupProgress(int groupIndex) {
    if (groupIndex < 0 || groupIndex >= questionGroups.length) return 0.0;
    // 1. Get all non-skipped questions for the current group.
    final activeQs = _activeQuestionsForGroup(groupIndex);
    if (activeQs.isEmpty) return 1.0;

    // 2. Count how many of them have been answered.
    int answered = _answeredCount(activeQs);

    // If we’re sitting at a group break, that group is effectively complete.
    if (isAwaitingGroupConfirmation.value &&
        currentGroupIndex.value == groupIndex) {
      answered = activeQs.length;
    }

    // 3. Calculate the progress (e.g., 2 answered / 4 total = 0.5)
    return (answered / activeQs.length).clamp(0.0, 1.0);
  }
}
