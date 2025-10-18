import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:image_picker/image_picker.dart';

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
        // 1. This is the new branching question
        const QAItem(
          id: 'has_target_event',
          question:
              "Do you have a specific date or event you’re working toward?",
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
        // This question is asked only if the answer above is "At home" or "A mix"
        const QAItem(
          id: 'home_equipment',
          question: "What equipment do you have access to at home?",
          type: QAType.choice,
          options: [
            'None',
            'Weights',
            'Barbell',
            'Bands'
                'Cardio equipment',
            'Both',
            'Other',
          ],
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
                'Other',
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
        //
        const QAItem(
          id: 'set_reminder',
          question: "Would you like to set a reminder for your selected time?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        //  Asks for the time if the answer above was "Yes"
        const QAItem(
          id: 'reminder_time',
          question: "Great! At what time would you like to be reminded?",
          type: QAType.time, // Assumes a new QAType.time for a time picker
          hint: "Select a time",
        ),
        const QAItem(
          id: 'focus_on_body_parts',
          question: "Are there any specific body parts you want to focus on?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        // This question is asked only if the answer above is "Yes"
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
            'Custom number'
                "Not sure yet",
          ],
        ),
        const QAItem(
          id: 'daily_step_goal_custom',
          question: "What is your custom daily step goal?",
          type: QAType.number,
          hint: "e.g., 7500",
        ),
        // START: Add these new questions
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
        // This question is asked only if the answer above is "Other"
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
        // This question is asked only if the answer above is "Other"
        const QAItem(
          id: 'stress_sources_other',
          question: "Please specify what 'Other' sources of stress you have.",
          type: QAType.text,
          hint: "Optional: e.g., Social life, personal goals",
          canSkip: true,
        ),
        // START: New Injury Questions
        const QAItem(
          id: 'has_injuries',
          question:
              "Do you have any injuries or conditions that impact your fitness?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        // This question is asked only if the answer above is "Yes"
        const QAItem(
          id: 'injury_name_1',
          question: "What is the injury or condition?",
          type: QAType.text,
          hint: "e.g., Lower back pain, Knee tendinitis",
        ),
        // This question is also asked only if the answer is "Yes"
        const QAItem(
          id: 'injury_description_1',
          question: "Please briefly describe it and any limitations it causes.",
          type: QAType.text,
          hint: "Optional: e.g., 'Can't do heavy squats'",
          canSkip: true,
        ),
        // This question is also asked only if the answer is "Yes"
        const QAItem(
          id: 'add_another_injury',
          question: "Would you like to add another injury or condition?",
          type: QAType.choice,
          options: ["Yes", "No"],
        ),
        // This question is asked only if the answer above is "Yes"
        const QAItem(
          id: 'injury_name_2',
          question: "What is the next injury or condition?",
          type: QAType.text,
          hint: "e.g., Shoulder impingement",
        ),
        // This question is also asked only if the answer is "Yes"
        const QAItem(
          id: 'injury_description_2',
          question: "Please briefly describe this one.",
          type: QAType.text,
          hint: "Optional",
          canSkip: true,
        ),
        // END: New Injury Questions
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
    // in lib/app/modules/trainee_onboarding/controllers/trainee_onboarding_controller.dart

    // ------------ Body Profile
    QuestionGroup(
      name: 'Body Profile',
      introduction: "Next, let's get some body profile details.",
      // ADDED: A conclusion message for the end of this group.
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
        // REMOVED: The duplicate 'thigh_measurement' question that was here.
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

  // In TraineeOnboardingController, add this with your other reactive properties
  final isAwaitingFinalContinuation = false.obs;

  /// True when the UI should show the "Continue" and "Skip" buttons.
  bool get showGroupContinuationButtons => isAwaitingGroupConfirmation.value;

  @override
  void onInit() {
    super.onInit();
    start();
  }

  // In TraineeOnboardingController, after the onInit() method

  Future<void> continueToNextGroup() async {
    if (!isAwaitingGroupConfirmation.value) return;
    isAwaitingGroupConfirmation.value = false;

    // Advance to the next group and ask its first question
    currentGroupIndex.value++;
    currentQuestionIndexInGroup.value = -1;
    await _askNext();
  }

  Future<void> skipToEnd() async {
    if (!isAwaitingGroupConfirmation.value) return;
    isAwaitingGroupConfirmation.value = false;
    await _completeOnboarding();
  }

  void start() async {
    messages.clear();
    answers.clear();
    currentGroupIndex.value = 0;
    currentQuestionIndexInGroup.value = -1; // Start before the first question
    await _botSay("Hello 👋");
    await _askNext();
  }

  // Future<void> _completeOnboarding() async {
  //   currentGroupIndex.value = questionGroups.length; // Set to "done" state
  //   await _botSay("All set! 🎉 Thanks for the info.");
  // final summary = answers.entries
  //     .map((e) => "• ${e.key}: ${e.value}")
  //     .join("\n");
  //   await _botSay("Here's a summary of your answers:\n$summary");
  //   await _botSay("You can now proceed, or use the ↺ button to restart.");
  // }

  Future<void> _completeOnboarding() async {
    currentGroupIndex.value =
        questionGroups.length; // Mark flow as internally "done"
    await _botSay("All set! 🎉 Thanks for the info.");
    await _botSay("Grading and storing all your information...");
    await _botSay(
      "To save your progress and create your personalized profile, you'll need to create a account.",
    );

    // Set the new state to show the final "Continue" button in the UI
    isAwaitingFinalContinuation.value = true;
  }

  // Add this new method to handle the final action
  void proceedToSignup() {
    // Here, you would navigate to your signup/registration page.
    // It's a good practice to pass the collected answers along.
    // For example, using GetX navigation:

    // For demonstration, we'll just show a snackbar.
    CustomToast.showSuccessToast( "Onboarding Complete");
    Get.toNamed(Routes.REGISTER, arguments: toJson());

    "Proceeding to signup with data: ${toJson()}".log();
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
    // If we are waiting for the user to press "Continue" or "Skip", do nothing.
    if (isAwaitingGroupConfirmation.value) return;

    // Determine the next position
    int nextQuestionIndex = currentQuestionIndexInGroup.value;
    int nextGroupIndex = currentGroupIndex.value;

    // Loop to find the next valid, non-skipped question
    while (true) {
      nextQuestionIndex++;

      // Check if the current group is finished
      if (nextGroupIndex < questionGroups.length &&
          nextQuestionIndex >=
              questionGroups[nextGroupIndex].questions.length) {
        // --- START: End-of-Group Logic ---
        final finishedGroup = questionGroups[nextGroupIndex];

        // 1. Show the group's conclusion message if it exists
        if (finishedGroup.conclusion != null) {
          await _botSay(finishedGroup.conclusion!);
        }

        // 2. Generate and show a summary for the just-completed group
        final summaryLines = <String>[];
        for (final question in finishedGroup.questions) {
          if (answers.containsKey(question.id)) {
            final questionText = question.question.replaceAll('?', '');
            // Using a more readable format for the summary
            summaryLines.add("• $questionText: **${answers[question.id]}**");
          }
        }
        if (summaryLines.isNotEmpty) {
          await _botSay(
            "Here's a summary for this section:\n${summaryLines.join('\n')}",
          );
        }

        // 3. If this was the VERY LAST group, complete the whole flow
        if (nextGroupIndex >= questionGroups.length - 1) {
          await _completeOnboarding();
          return; // End the entire process
        }

        // 4. Otherwise, prompt the user and wait for them to Continue or Skip
        isAwaitingGroupConfirmation.value = true;
        // ---  Show remaining group names ---
        final remainingGroups = questionGroups.sublist(nextGroupIndex + 1);
        final remainingGroupNames =
        remainingGroups.map((g) => "• ${g.name}").join('\n');

        await _botSay(
          "Great job! To create the best plan, we still need to cover these topics:\n$remainingGroupNames",
        );
        await _botSay("Ready to continue?");
        return; // IMPORTANT: Exit _askNext and wait for user action
        // --- End-of-Group Logic ---
      }

      // This case is now handled by the logic above, but serves as a fallback.
      if (nextGroupIndex >= questionGroups.length) {
        await _completeOnboarding();
        return;
      }

      final questionCandidate =
          questionGroups[nextGroupIndex].questions[nextQuestionIndex];

      // --- all skip rules remain the same ---
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

      // Rule 7: Skip specific body parts if user answered "No"
      if (questionCandidate.id == 'specific_body_parts' &&
          answers['focus_on_body_parts'] == 'No') {
        shouldSkip = true;
      }

      // Rule 8: Skip custom step goal if user didn't select 'Custom number'
      if (questionCandidate.id == 'daily_step_goal_custom' &&
          answers['daily_step_goal'] != 'Custom number') {
        shouldSkip = true;
      }

      // Rule 9: Skip 'other' limitations if user didn't select 'Other'
      if (questionCandidate.id == 'training_limitations_other' &&
          answers['training_limitations'] != 'Other') {
        shouldSkip = true;
      }

      // Rule 10: Skip 'other' stress sources if user didn't select 'Other'
      if (questionCandidate.id == 'stress_sources_other' &&
          answers['stress_sources'] != 'Other') {
        shouldSkip = true;
      }

      // Rule 11: Skip all injury questions if user answered "No"
      if ((questionCandidate.id == 'injury_name_1' ||
              questionCandidate.id == 'injury_description_1' ||
              questionCandidate.id == 'add_another_injury' ||
              questionCandidate.id == 'injury_name_2' ||
              questionCandidate.id == 'injury_description_2') &&
          answers['has_injuries'] == 'No') {
        shouldSkip = true;
      }

      // Rule 12: Skip second injury questions if user doesn't want to add more
      if ((questionCandidate.id == 'injury_name_2' ||
              questionCandidate.id == 'injury_description_2') &&
          answers['add_another_injury'] != 'Yes') {
        shouldSkip = true;
      }

      // Rule 13: Skip 'other' recovery obstacles if user didn't select 'Other'
      if (questionCandidate.id == 'recovery_obstacles_other' &&
          answers['recovery_obstacles'] != 'Other') {
        shouldSkip = true;
      }

      // Rule 14: Skip body measurement questions if user answered "No"
      const measurementIds = {
        'chest_measurement',
        'waist_measurement',
        'hips_measurement',
        'arm_measurement',
        'thigh_measurement',
      };

      // Rule 15: Skip body measurement questions if user answered "No"
      if (measurementIds.contains(questionCandidate.id) &&
          answers['add_body_measurements'] != 'Yes') {
        shouldSkip = true;
      }

      // Rule 15: Skip the photo picker if the user answered "No"
      if (questionCandidate.id == 'progress_photo_picker' &&
          answers['upload_progress_photo'] != 'Yes') {
        shouldSkip = true;
      }

      if (!shouldSkip) {
        // Found a valid question, break the loop to ask it
        break;
      }
    }

    // If we are starting a new group, show its introduction message
    final bool isNewGroup =
        nextQuestionIndex == 0 &&
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
      !isFinished && !isTyping.value && currentQuestionIndexInGroup.value != -1;

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

      // Rule 7
      if (questionCandidate.id == 'specific_body_parts' &&
          answers['focus_on_body_parts'] == 'No') {
        wasSkipped = true;
      }

      // Rule 8
      if (questionCandidate.id == 'daily_step_goal_custom' &&
          answers['daily_step_goal'] != 'Custom number') {
        wasSkipped = true;
      }

      // Rule 9
      if (questionCandidate.id == 'training_limitations_other' &&
          answers['training_limitations'] != 'Other') {
        wasSkipped = true;
      }

      // Rule 10
      if (questionCandidate.id == 'stress_sources_other' &&
          answers['stress_sources'] != 'Other') {
        wasSkipped = true;
      }

      // Rule 11
      if ((questionCandidate.id == 'injury_name_1' ||
              questionCandidate.id == 'injury_description_1' ||
              questionCandidate.id == 'add_another_injury' ||
              questionCandidate.id == 'injury_name_2' ||
              questionCandidate.id == 'injury_description_2') &&
          answers['has_injuries'] == 'No') {
        wasSkipped = true;
      }

      // Rule 12
      if ((questionCandidate.id == 'injury_name_2' ||
              questionCandidate.id == 'injury_description_2') &&
          answers['add_another_injury'] != 'Yes') {
        wasSkipped = true;
      }

      // Rule 13
      if (questionCandidate.id == 'recovery_obstacles_other' &&
          answers['recovery_obstacles'] != 'Other') {
        wasSkipped = true;
      }

      // Rule 14
      const measurementIds = {
        'chest_measurement',
        'waist_measurement',
        'hips_measurement',
        'arm_measurement',
        'thigh_measurement',
      };
      if (measurementIds.contains(questionCandidate.id) &&
          answers['add_body_measurements'] != 'Yes') {
        wasSkipped = true;
      }

      // Rule 15: Skip the photo picker if the user answered "No"
      if (questionCandidate.id == 'progress_photo_picker' &&
          answers['upload_progress_photo'] != 'Yes') {
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

  // handler for the height picker
  Future<void> selectHeight({int? cm, int? feet, int? inches}) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    String formattedHeight;

    if (cm != null) {
      formattedHeight = "$cm cm";
    } else if (feet != null && inches != null) {
      formattedHeight = "$feet' $inches\"";
    } else {
      // This case would be triggered by a "Skip" button in the UI
      _saveUserAnswer(q, "Skipped");
      await _askNext();
      return;
    }

    _saveUserAnswer(q, formattedHeight);
    await _askNext();
  }

  // handler for the weight picker
  Future<void> selectWeight({double? weight, String? unit}) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;

    if (weight == null || unit == null) {
      // This case would be triggered by a "Skip" button in the UI
      _saveUserAnswer(q, "Skipped");
      await _askNext();
      return;
    }
    // Format to one decimal place for consistency
    final formattedWeight = "${weight.toStringAsFixed(1)} $unit";

    _saveUserAnswer(q, formattedWeight);
    await _askNext();
  }

  /// The UI should call this after using image_picker to get a file.
  Future<void> selectImage(XFile imageFile) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;

    // The answer map stores the file path for later use (e.g., uploading).
    answers[q.id] = imageFile.path;

    // MODIFIED: Create a ChatMessage containing the image path instead of text.
    messages.add(
      ChatMessage(from: Sender.user, imagePath: imageFile.path, text: ''),
    );
    _scrollToBottom();

    // Proceed to the next step in the onboarding flow.
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

  bool get isCurrentHeight => currentQuestion?.type == QAType.height;

  bool get isCurrentWeight => currentQuestion?.type == QAType.weight;

  bool get isCurrentImage => currentQuestion?.type == QAType.image;
}
