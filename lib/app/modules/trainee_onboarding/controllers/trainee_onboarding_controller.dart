import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/network/network_error/api_error_handler.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/trainee_onboarding/repository/traineer_onboarding_qa_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/local/preference/store/trainee_data_store.dart';
import '../../../routes/app_pages.dart';
import '../models/onboarding_qa_model.dart';
import '../models/trainee_onboarding_questions_model.dart';

class TraineeOnboardingController extends BaseController {
  // --------------- Repository ---------------
  final TraineeOnboardingQARepository _onboardingQARepository = Get.find(
    tag: (TraineeOnboardingQARepository).toString(),
  );
  final textController = TextEditingController();

  // --------------- Dynamic Data ---------------
  /// This will hold the groups generated from the fetched API data.
  final RxList<QuestionGroup> generatedQuestionGroups = <QuestionGroup>[].obs;
  /// This holds the raw fetched data for reference.
  final RxList<TraineeQuestionData> questionData = <TraineeQuestionData>[].obs;

  // --------------- UI State ---------------
  final RxBool isLoading = true.obs;
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final inputText = ''.obs;
  final currentGroupIndex = 0.obs;
  final currentQuestionIndexInGroup = (-1).obs;
  final isAwaitingGroupConfirmation = false.obs;
  final isAwaitingFinalContinuation = false.obs;
  final hasAgreedToTerms = false.obs;
  final pageController = ScrollController();

  // --------------- Answers ---------------
  final Map<String, String> answers = {};

  /// True when the UI should show the "Continue" and "Skip" buttons.
  bool get showGroupContinuationButtons => isAwaitingGroupConfirmation.value;

  //-------------------- QA Stepper --------------------
  final RxDouble currentGroupProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Progress updates are now tied to the dynamic groups
    currentGroupIndex.listen((_) => _updateProgresses());
    currentQuestionIndexInGroup.listen((_) => _updateProgresses());
    isAwaitingGroupConfirmation.listen((_) => _updateProgresses());
  }

  @override
  void onReady() {
    super.onReady();
    _initializeOnboarding();
  }

  /// Fetches data, builds question groups, and starts the conversation.
  Future<void> _initializeOnboarding() async {
    isLoading(true);
    try {
      // Fetch the flat list of questions from the repository
      final questionResponse =
      await _onboardingQARepository.fetchQuestionsData(1);
      questionData.assignAll(questionResponse.questionsData);

      // Build the structured QuestionGroup list from the flat data
      _buildQuestionGroupsFromData(questionData);

      // Start the conversation flow
      start();
    } catch (error) {
      // Handle API or other errors
      if (error is ApiException) {
        apiErrorHandler(fallbackMessage: error.description);
      } else {
        CustomToast.showErrorToast('Error initializing onboarding: $error');
      }
    } finally {
      isLoading(false);
    }
  }

  /// Divides the flat list of questions into 6 groups.
  void _buildQuestionGroupsFromData(List<TraineeQuestionData> allQuestions) {
    if (allQuestions.isEmpty) {
      generatedQuestionGroups.clear();
      return;
    }

    // Predefined titles and intros for the 6 groups. You can customize these.
    final groupMetadatas = [
      {
        'name': 'Getting Started',
        'intro': "To start, let's get some personal details."
      },
      {
        'name': 'Fitness Background',
        'intro': "Great! Now for a bit about your fitness background."
      },
      {
        'name': 'Goals & Activity',
        'intro': "Let's talk about your goals and activity levels."
      },
      {
        'name': 'Nutrition',
        'intro': 'Now, a few questions about your nutrition habits.'
      },
      {
        'name': 'Health & Recovery',
        'intro': "Finally, let's talk about your health and recovery."
      },
      {
        'name': 'Body Profile',
        'intro': "Excellent! Let's get your body profile details to track progress.",
        'conclusion': "That's everything I need to know. Thanks for sharing!"
      },
    ];

    const int numberOfGroups = 6;
    final int questionsPerGroup = (allQuestions.length / numberOfGroups).ceil();
    final List<QuestionGroup> newGroups = [];

    for (int i = 0; i < numberOfGroups; i++) {
      if (i * questionsPerGroup >= allQuestions.length) break;

      final int start = i * questionsPerGroup;
      final int end = (start + questionsPerGroup > allQuestions.length)
          ? allQuestions.length
          : start + questionsPerGroup;

      final groupQuestionsData = allQuestions.sublist(start, end);

      final groupQAItems =
      groupQuestionsData.map((data) => _mapDataToQAItem(data)).toList();

      if (groupQAItems.isNotEmpty) {
        final metadata = groupMetadatas[i];
        newGroups.add(
          QuestionGroup(
            name: metadata['name']!,
            introduction: metadata['intro']!,
            conclusion: metadata['conclusion'],
            questions: groupQAItems,
          ),
        );
      }
    }
    generatedQuestionGroups.assignAll(newGroups);
  }

  /// Maps a [TraineeQuestionData] object from the API to a [QAItem] used by the chat UI.
  QAItem _mapDataToQAItem(TraineeQuestionData data) {
    return QAItem(
      // Use questionFieldName as the unique ID for the answer map
      id: data.questionFieldName ?? data.id.toString(),
      question: data.questionText ?? 'No question text',
      type: data.questionType ?? QAType.unknown,
      options: data.possibleAnswersMetadata?.choices ?? [],
      // These fields are not available from the API, so we use defaults.
      hint: null,
      canSkip: false, // Set to false as we can't determine this from the API data
    );
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

  void toggleTermsAgreement(bool? newValue) {
    hasAgreedToTerms.value = newValue ?? false;
  }

  void start() async {
    messages.clear();
    answers.clear();
    currentGroupIndex.value = 0;
    currentQuestionIndexInGroup.value = -1;
    hasAgreedToTerms.value = false;
    isAwaitingFinalContinuation.value = false;
    isAwaitingGroupConfirmation.value = false;
    _updateProgresses();
    await _botSay("Hello 👋");
    await _askNext();
  }

  Future<void> _completeOnboarding() async {
    currentGroupIndex.value = generatedQuestionGroups.length; // done
    _updateProgresses();
    await _botSay("All set! 🎉 Thanks for the info.");
    await _botSay("Grading and storing all your information...");
    await _botSay(
      "To save your progress and create your personalized icon profile, you'll need to agree out terms and conditions to continue.",
    );
    isAwaitingFinalContinuation.value = true;
  }

  void proceedToContinue() {
    if (!hasAgreedToTerms.value) {
      CustomToast.showErrorToast(
        "Please agree to the terms and conditions to continue.",
      );
      return;
    }
    try {
      final onboardingJson = toJson();
      Get.find<TraineeDataStore>().saveOnboardingData(onboardingJson);
      CustomToast.showSuccessToast('Profile data saved successfully.');
      Get.toNamed(
        Routes.TRAINEE_FITNESS_REPORT_GENERATION,
        arguments: onboardingJson,
      );
      "Proceeding to fitness report with data: $onboardingJson".log();
    } catch (e) {
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
  /// NOTE: The complex, hardcoded skip logic has been removed.
  /// With dynamic questions from an API, it's not safe to assume which questions
  /// will exist or what their dependencies are. This function now returns false,
  /// meaning all fetched questions will be asked sequentially.
  /// You can re-introduce skip logic here based on the `question_field_name`
  /// if you have guaranteed dependencies in your API data.
  bool _shouldSkipQuestion(QAItem q) {
    // Example of how you could add new skip logic:
    // if (q.id == 'dietary_restrictions_other' && answers['current_dietary_restrictions'] != 'Other') {
    //   return true;
    // }
    return false;
  }

  // -------------------- Active/answered helpers --------------------
  List<QAItem> _activeQuestionsForGroup(int gi) {
    if (gi < 0 || gi >= generatedQuestionGroups.length) return const [];
    return generatedQuestionGroups[gi]
        .questions
        .where((q) => !_shouldSkipQuestion(q))
        .toList();
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
    if (generatedQuestionGroups.isEmpty) return 0.0;

    int totalActive = 0;
    int totalAnswered = 0;

    for (int gi = 0; gi < generatedQuestionGroups.length; gi++) {
      final activeQs = _activeQuestionsForGroup(gi);
      totalActive += activeQs.length;

      if (isAwaitingGroupConfirmation.value && gi < currentGroupIndex.value) {
        totalAnswered += activeQs.length;
        continue;
      }

      totalAnswered += _answeredCount(activeQs);
    }

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

    if (generatedQuestionGroups.isEmpty) {
      await _completeOnboarding();
      return;
    }

    while (true) {
      nextQuestionIndex++;

      if (nextGroupIndex < generatedQuestionGroups.length &&
          nextQuestionIndex >=
              generatedQuestionGroups[nextGroupIndex].questions.length) {
        final finishedGroup = generatedQuestionGroups[nextGroupIndex];

        if (finishedGroup.conclusion != null) {
          await _botSay(finishedGroup.conclusion!);
        }

        final summaryLines = <String>[];
        for (final question in finishedGroup.questions) {
          final ans = answers[question.id];
          if (ans != null && ans.isNotEmpty) {
            final qt = question.question.replaceAll('?', '');
            summaryLines.add("• $qt: **$ans**");
          }
        }
        if (summaryLines.isNotEmpty) {
          await _botSay(
            "Here's a summary for this section:\n${summaryLines.join('\n')}",
          );
        }

        if (nextGroupIndex >= generatedQuestionGroups.length - 1) {
          await _completeOnboarding();
          return;
        }

        isAwaitingGroupConfirmation.value = true;

        final remainingGroups =
        generatedQuestionGroups.sublist(nextGroupIndex + 1);
        final remainingGroupNames =
        remainingGroups.map((g) => "• ${g.name}").join('\n');

        await _botSay(
          "Great job! To create the best plan, we still need to cover these topics:\n$remainingGroupNames",
        );
        await _botSay("Ready to continue?");
        _updateProgresses();
        return;
      }

      if (nextGroupIndex >= generatedQuestionGroups.length) {
        await _completeOnboarding();
        return;
      }

      final candidate =
      generatedQuestionGroups[nextGroupIndex].questions[nextQuestionIndex];

      if (!_shouldSkipQuestion(candidate)) break;
    }

    final bool isNewGroup = nextQuestionIndex == 0 &&
        (currentGroupIndex.value != nextGroupIndex ||
            currentQuestionIndexInGroup.value == -1);

    if (isNewGroup) {
      await _botSay(generatedQuestionGroups[nextGroupIndex].introduction);
    }

    final q =
    generatedQuestionGroups[nextGroupIndex].questions[nextQuestionIndex];
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

  Future<void> choose(String option) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    _saveUserAnswer(q, option);
    await _askNext();
  }

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
        _saveUserAnswer(q, "Skip");
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
  bool get isFinished =>
      currentGroupIndex.value >= generatedQuestionGroups.length;

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
        if (targetGroupIndex < 0) break;
        targetQuestionIndex =
            generatedQuestionGroups[targetGroupIndex].questions.length - 1;
      }

      final candidate =
      generatedQuestionGroups[targetGroupIndex].questions[targetQuestionIndex];

      if (!_shouldSkipQuestion(candidate)) break;
    }

    if (targetGroupIndex < 0) {
      start();
      return;
    }

    final q =
    generatedQuestionGroups[targetGroupIndex].questions[targetQuestionIndex];
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

  int get stepperTotalSteps => generatedQuestionGroups.length;

  int get stepperCurrentStep {
    if (isFinished && generatedQuestionGroups.isNotEmpty) {
      return generatedQuestionGroups.length - 1;
    }
    return currentGroupIndex.value.clamp(
      0,
      (generatedQuestionGroups.length - 1).clamp(0, 1 << 30),
    );
  }

  double get stepperStepProgress {
    final n = generatedQuestionGroups.length;
    if (n <= 1) return _globalProgress();

    final gp = _globalProgress();
    final overall = gp * (n - 1);
    final stepProg = (overall - stepperCurrentStep).clamp(0.0, 1.0);
    return stepProg;
  }

  // ------------ Convenience flags for input UI ------------
  QAItem? get currentQuestion {
    if (isFinished ||
        currentGroupIndex.value >= generatedQuestionGroups.length ||
        currentQuestionIndexInGroup.value < 0 ||
        currentQuestionIndexInGroup.value >=
            generatedQuestionGroups[currentGroupIndex.value].questions.length) {
      return null;
    }
    return generatedQuestionGroups[currentGroupIndex.value]
        .questions[currentQuestionIndexInGroup.value];
  }

  String? get getCurrentGroupName {
    if (currentGroupIndex.value >= 0 &&
        currentGroupIndex.value < generatedQuestionGroups.length) {
      return generatedQuestionGroups[currentGroupIndex.value].name;
    }
    return null;
  }

  bool get isCurrentChoice => currentQuestion?.type == QAType.multipleChoice;
  bool get isCurrentDate => currentQuestion?.type == QAType.date;
  bool get isCurrentTime => currentQuestion?.type == QAType.time;
  bool get isCurrentHeight => currentQuestion?.type == QAType.height;
  bool get isCurrentWeight => currentQuestion?.type == QAType.weight;
  bool get isCurrentImage => currentQuestion?.type == QAType.image;

  // -------------- Stepper bindings --------------
  void _updateProgresses() {
    if (isFinished ||
        currentGroupIndex.value >= generatedQuestionGroups.length) {
      currentGroupProgress.value = 0.0;
    } else {
      currentGroupProgress.value = _computeGroupProgress(
        currentGroupIndex.value,
      );
    }
  }

  // -------------- Per-group progress (for section UIs) --------------
  double _computeGroupProgress(int groupIndex) {
    if (groupIndex < 0 || groupIndex >= generatedQuestionGroups.length) {
      return 0.0;
    }
    final activeQs = _activeQuestionsForGroup(groupIndex);
    if (activeQs.isEmpty) return 1.0;

    int answered = _answeredCount(activeQs);

    if (isAwaitingGroupConfirmation.value &&
        currentGroupIndex.value == groupIndex) {
      answered = activeQs.length;
    }

    return (answered / activeQs.length).clamp(0.0, 1.0);
  }
}