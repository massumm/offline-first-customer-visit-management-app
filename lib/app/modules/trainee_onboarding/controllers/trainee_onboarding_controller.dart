import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/network/network_error/api_error_handler.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/trainee_onboarding/repository/traineer_onboarding_qa_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../../base/repository/trainee_onboarding_auth_repo/trainee_onboarding_auth_repository.dart';
import '../../../data/local/preference/store/trainee_data_store.dart';
import '../../../data/local/preference/store/user_store.dart';
import '../../../routes/app_pages.dart';
import '../../login/models/login_response_model.dart';
import '../models/onboarding_qa_model.dart';
import '../models/trainee_onboarding_questions_model.dart';

enum OnboardingPhase {
  awaitingEmail,
  awaitingInitialTerms,
  fetchingData,
  askingQuestions,
  completed,
}

class TraineeOnboardingController extends BaseController {
  // --------------- Repository ---------------
  final TraineeOnboardingQARepository _onboardingQARepository = Get.find(
    tag: (TraineeOnboardingQARepository).toString(),
  );

  final TraineeOnboardingAuthRepository _onboardingAuthRepository = Get.find(
    tag: (TraineeOnboardingAuthRepository).toString(),
  );
  final textController = TextEditingController();

  // --------------- Dynamic Data ---------------
  /// This will hold the groups generated from the fetched API data.
  final RxList<QuestionGroup> generatedQuestionGroups = <QuestionGroup>[].obs;

  /// This holds the raw fetched data for reference.
  final RxList<TraineeQuestionData> questionData = <TraineeQuestionData>[].obs;

  // --------------- UI State ---------------
  final Rx<OnboardingPhase> onboardingPhase = OnboardingPhase.awaitingEmail.obs;
  final RxString userEmail = ''.obs;
  final RxBool hasAgreedToInitialTerms = false.obs;

  final RxBool isLoading = true.obs;
  final RxBool isEmailLoading = true.obs;
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final inputText = ''.obs;
  final currentGroupIndex = (-1).obs;
  final currentQuestionIndexInGroup = (-1).obs;
  final isAwaitingGroupConfirmation = false.obs;
  final pageController = ScrollController();
  var _isRevisiting = false;

  // --------------- Answers ---------------
  final Map<int, String> answers = {};

  /// True when the UI should show the "Continue" and "Skip" buttons.
  bool get showGroupContinuationButtons => isAwaitingGroupConfirmation.value;

  //-------------------- QA Stepper --------------------
  /// Holds the progress (0.0 to 1.0) for each question group.
  final RxList<double> groupProgresses = <double>[].obs;

  RxInt traineeId = 1.obs;

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
    start();
  }

  /// Fetches data, builds question groups, and starts the conversation.
  Future<void> _fetchAndSetupQuestions() async {
    onboardingPhase.value = OnboardingPhase.fetchingData;
    isLoading(true);
    try {
      // Fetch the flat list of questions from the repository
      final questionResponse = await _onboardingQARepository.fetchQuestionsData(
        1,
      );
      questionData.assignAll(questionResponse.questionsData);

      // Build the structured QuestionGroup list from the flat data
      _buildQuestionGroupsFromData(questionData);

      // Start the conversation flow
      onboardingPhase.value = OnboardingPhase.askingQuestions;
      await _askNext();
    } catch (error) {
      // Revert state on error so user can try again
      onboardingPhase.value = OnboardingPhase.awaitingInitialTerms;
      if (error is ApiException) {
        apiErrorHandler(fallbackMessage: error.description);
      } else {
        CustomToast.showErrorToast('Error initializing onboarding: $error');
      }
    } finally {
      isLoading(false);
    }
  }


  void _buildQuestionGroupsFromData(List<TraineeQuestionData> allQuestions) {
    if (allQuestions.isEmpty) {
      generatedQuestionGroups.clear();
      groupProgresses.clear();
      return;
    }


    const groupOrder = [
      'Personal Information',
      'Goals & Activity',
      'Nutrition',
      'Health & Recovery',
      'Body Profile',
      'general',
    ];


    final groupMetadatas = {
      'Personal Information': {
        'intro': "Great! Now for a bit about your Personal data.",
      },
      'Goals & Activity': {
        'intro': "Let's talk about your goals and activity levels.",
      },
      'Nutrition': {
        'intro': 'Now, a few questions about your nutrition habits.',
      },
      'Health & Recovery': {
        'intro': "Finally, let's talk about your health and recovery.",
      },
      'Body Profile': {
        'intro':
        "Excellent! Let's get your body profile details to track progress.",
        'conclusion': "That's everything I need to know. Thanks for sharing!",
      },
      // Added metadata for the 'general' group to match the API data
      'general': {
        'intro': "Great! Let's get started with some general questions.",
        'conclusion': "Thanks for providing the details.",
      },
    };


    final Map<String, List<TraineeQuestionData>> questionsByGroup = {};
    for (final question in allQuestions) {

      final String groupName;
      if (question.groupName.isNotEmpty) {
        groupName = question.groupName;
      } else {
        groupName = 'Uncategorized';
      }
      (questionsByGroup[groupName] ??= []).add(question);
    }


    final List<QuestionGroup> newGroups = [];
    for (final groupName in groupOrder) {
      final groupQuestionsData = questionsByGroup[groupName];

      if (groupQuestionsData != null && groupQuestionsData.isNotEmpty) {
        final groupQAItems =
        groupQuestionsData.map((data) => _mapDataToQAItem(data)).toList();

        final metadata = groupMetadatas[groupName];
        if (metadata != null) {
          newGroups.add(
            QuestionGroup(
              name: groupName,
              introduction: metadata['intro']!,
              conclusion: metadata['conclusion'],
              questions: groupQAItems,
            ),
          );
        }
      }
    }


    if (newGroups.isEmpty) {
      "Warning: No question groups were created. Check if the 'group_name' values from the API match the 'groupOrder' list in the controller.".log();
    }

    generatedQuestionGroups.assignAll(newGroups);
    // Initialize progress for each dynamically created group.
    groupProgresses.assignAll(List.filled(newGroups.length, 0.0));
  }

  /// Maps a [TraineeQuestionData] object from the API to a [QAItem] used by the chat UI.
  QAItem _mapDataToQAItem(TraineeQuestionData data) {
    return QAItem(
      id: data.id ?? 1,
      question: data.questionText ?? 'No question text',
      type: data.questionType ?? QAType.unknown,
      questionFieldName: data.questionFieldName,
      possibleAnswersMetadata: data.possibleAnswersMetadata,
      options: data.possibleAnswersMetadata?.choices ?? [],
      hint: null,
      canSkip: data.isOptional,
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

  void toggleInitialTermsAgreement(bool? newValue) {
    hasAgreedToInitialTerms.value = newValue ?? false;
  }

  void proceedAfterInitialTerms() {
    if (!hasAgreedToInitialTerms.value) {
      CustomToast.showErrorToast(
        "Please agree to the terms and conditions to continue.",
      );
      return;
    }
    // User has agreed, now fetch questions and proceed.
    _fetchAndSetupQuestions();
  }

  void start() async {
    // Reset all state for a fresh start
    messages.clear();
    answers.clear();
    userEmail.value = '';
    hasAgreedToInitialTerms.value = false;
    currentGroupIndex.value = -1;
    currentQuestionIndexInGroup.value = -1;
    isAwaitingGroupConfirmation.value = false;
    _updateProgresses();

    // Begin the new onboarding flow
    onboardingPhase.value = OnboardingPhase.awaitingEmail;
    await _botSay("Hello 👋");
    await _botSay("To get started, please enter your email address.");
    isLoading(false); // Ensure loading is false for initial interaction
  }

  Future<void> _askForInitialTerms() async {
    onboardingPhase.value = OnboardingPhase.awaitingInitialTerms;
    await _botSay(
      "Great. Please review and agree to our terms and conditions to continue.",
    );
  }

  Future<void> _completeOnboarding() async {
    onboardingPhase.value = OnboardingPhase.completed;
    currentGroupIndex.value = generatedQuestionGroups.length; // Mark as done
    _updateProgresses();
    await _botSay("All set! 🎉 Thanks for the info.");
    await _botSay("Grading and storing all your information...");

    // Since terms are agreed to at the start, we can proceed directly.
    try {
      final onboardingJson = toJson();
      Get.find<TraineeDataStore>().saveOnboardingData(onboardingJson);
      CustomToast.showSuccessToast('Profile data saved successfully.');
      Future.delayed(Duration(seconds: 1), () =>
          Get.toNamed(
              Routes.TRAINEE_FITNESS_REPORT_GENERATION,
              arguments: traineeId.value
            // onboardingJson,
          )
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
    // Bot messages are immediately delivered
    messages.add(
        ChatMessage(from: Sender.bot, text: text, status: MessageStatus.delivered));
    isTyping.value = false;
    _scrollToBottom();
  }

  bool _shouldSkipQuestion(QAItem q) {
    return false;
  }

  List<QAItem> _activeQuestionsForGroup(int gi) {
    if (gi < 0 || gi >= generatedQuestionGroups.length) return const [];
    return generatedQuestionGroups[gi].questions
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

    if (isFinished) return 1.0;
    if (totalActive == 0) return 0.0;

    final gp = totalAnswered / totalActive;
    return gp.clamp(0.0, 1.0);
  }

  Future<void> _askNext() async {
    if (onboardingPhase.value != OnboardingPhase.askingQuestions) return;
    if (isAwaitingGroupConfirmation.value) return;

    // This is the first question after setup, set indices to start
    if (currentGroupIndex.value < 0) {
      currentGroupIndex.value = 0;
      currentQuestionIndexInGroup.value = -1;
    }

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

        if (nextGroupIndex >= generatedQuestionGroups.length - 1) {
          await _completeOnboarding();
          return;
        }

        isAwaitingGroupConfirmation.value = true;

        final remainingGroups = generatedQuestionGroups.sublist(
          nextGroupIndex + 1,
        );
        final remainingGroupNames = remainingGroups
            .map((g) => "• ${g.name}")
            .join('\n');

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

    final bool isNewGroup =
        nextQuestionIndex == 0 &&
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
    await _saveUserAnswer(q, option);
  }

  Future<void> _storeUserToken(LoginResponseModel response) async {
    try {
      await UserStore.to.saveProfileAndToken(response);
    } catch (e) {
      "Failed to store user token: ${e.toString()}".log();
      CustomToast.showErrorToast("Failed to save session. Please try again.");
    }
  }

  Future<bool> _registerUser(ChatMessage userMessage) async {
    if (onboardingPhase.value != OnboardingPhase.awaitingEmail) return false;

    isEmailLoading(true);
    // Mark the message as 'sending' before the API call
    userMessage.updateStatus(MessageStatus.sending);

    try {
      final response = await _onboardingAuthRepository.registerEmail({
        'email': userEmail.value,
      });
      await _storeUserToken(response);
      traineeId.value = response.traineeProfile?.id ?? 1; // Store the id
      // Mark as 'delivered' on success
      userMessage.updateStatus(MessageStatus.delivered);
      return true;
    } catch (e) {
      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      } else {
        CustomToast.showErrorToast(
          "An unexpected error occurred. Please try again.",
        );
      }
      // Mark as 'failed' on error
      userMessage.updateStatus(MessageStatus.failed);
      return false;
    } finally {
      isEmailLoading(false);
    }
  }

  Future<bool> _sendMessage(ChatMessage userMessage) async {
    // Mark the message as sending before the API call
    userMessage.updateStatus(MessageStatus.sending);

    try {
      final q = currentQuestion!;
      final answerData = {
        "trainee_profile": traineeId.value,
        "trainee_onboarding_question": q.id,
        "answer_text": answers[q.id],
        // "answer_metadata": q.possibleAnswersMetadata?.toJson(),
      };

      await _onboardingQARepository.sendAnswers(answerData, 1);

      userMessage.updateStatus(MessageStatus.delivered); // Mark as delivered on success
      return true;
    } catch (e) {
      userMessage.updateStatus(MessageStatus.failed); // Mark as failed on error
      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      } else {
        CustomToast.showErrorToast("Error sending message: $e");
      }
      return false;
    }
  }

  Future<bool> _updateMessage(ChatMessage userMessage) async {
    // Mark the message as sending before the API call
    userMessage.updateStatus(MessageStatus.sending);

    try {
      final q = currentQuestion!;
      final answerData = {
        "trainee_profile": traineeId.value,
        "trainee_onboarding_question": q.id,
        "answer_text": answers[q.id],
        // "answer_metadata": q.possibleAnswersMetadata?.toJson(),
      };

      await _onboardingQARepository.updateAnswers(answerData, 1, q.id);

      userMessage.updateStatus(MessageStatus.delivered); // Mark as delivered on success
      return true;
    } catch (e) {
      userMessage.updateStatus(MessageStatus.failed); // Mark as failed on error
      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      } else {
        CustomToast.showErrorToast("Error sending message: $e");
      }
      return false;
    }
  }

  Future<void> send(String text) async {
    final value = text.trim();

    // Handle email submission phase (already correctly handles success/failure for _registerUser)
    if (onboardingPhase.value == OnboardingPhase.awaitingEmail) {
      if (value.isEmail) {
        userEmail.value = value;
        final userMessage = ChatMessage(
          from: Sender.user,
          text: value,
          status: MessageStatus.pending,
        );
        messages.add(userMessage);
        _scrollToBottom();
        textController.clear();
        inputText.value = '';
        final bool didRegisterSuccessfully = await _registerUser(userMessage);
        if (didRegisterSuccessfully) {
          await _askForInitialTerms();
        }
      } else {
        await _botSay("Please enter a valid email address.");
      }
      return;
    }

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
        await _saveUserAnswer(q, "Skip");
        inputText.value = '';
        textController.clear();
      }
      return;
    }

    if (q.type == QAType.number && int.tryParse(value) == null) {
      await _botSay("Please enter a valid number 🔢");
      return;
    }

    inputText.value = '';
    textController.clear();
    await _saveUserAnswer(q, value);
  }

  // --- Helper Getters and Methods ---
  bool get isFinished => onboardingPhase.value == OnboardingPhase.completed;

  bool get _canAnswer =>
      onboardingPhase.value == OnboardingPhase.askingQuestions &&
          !isFinished &&
          !isTyping.value &&
          currentQuestionIndexInGroup.value != -1;

  Future<void> _saveUserAnswer(QAItem q, String value) async {
    final userMessage =
    ChatMessage(from: Sender.user, text: value, status: MessageStatus.pending);
    await _processAnswer(q, value, userMessage);
  }

  Future<void> _saveImageAnswer(QAItem q, XFile imageFile) async {
    final userMessage = ChatMessage(
      from: Sender.user,
      text: '',
      imagePath: imageFile.path,
      status: MessageStatus.pending,
    );
    await _processAnswer(q, imageFile.path, userMessage);
  }

  Future<void> _processAnswer(
      QAItem q, String answerValue, ChatMessage userMessage) async {
    messages.add(userMessage);

    final bool wasRevisiting = _isRevisiting;

    answers[q.id] = answerValue;
    _scrollToBottom();
    _updateProgresses();

    bool success = false;
    if (wasRevisiting) {
      // When revisiting, first attempt to update the existing answer.
      success = await _updateMessage(userMessage);
      if (!success) {
        // If the update fails (e.g., the answer didn't exist on the backend),
        // fall back to sending it as a new answer.
        "Update failed, attempting to send as a new answer.".log();
        success = await _updateMessage(userMessage);
      }
    } else {
      // For all other cases, send it as a new answer.
      success = await _sendMessage(userMessage);
    }

    // If either the update or the fallback send was successful, move to the next question.
    // Otherwise, stay on the current question; the message status will show 'failed'.
    if (success) {
      // Reset the flag after use so subsequent forward answers are "sends".
      _isRevisiting = false;
      await _askNext();
    }
  }

  bool get canGoBack =>
      !isFinished &&
          (currentGroupIndex.value > 0 || currentQuestionIndexInGroup.value > 0);

  Future<void> goBack() async {
    if (!canGoBack) return;

    _isRevisiting = true; // Flag that the user is navigating back
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
      'email': userEmail.value,
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
    await _saveUserAnswer(q, formattedDate);
  }

  Future<void> selectTime(TimeOfDay time, BuildContext context) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    final formattedTime = time.format(context);
    await _saveUserAnswer(q, formattedTime);
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
      await _saveUserAnswer(q, "Skipped");
      return;
    }

    await _saveUserAnswer(q, formattedHeight);
  }

  Future<void> selectWeight({double? weight, String? unit}) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    if (weight == null || unit == null) {
      await _saveUserAnswer(q, "Skipped");
      return;
    }
    final formattedWeight = "${weight.toStringAsFixed(1)} $unit";
    await _saveUserAnswer(q, formattedWeight);
  }

  Future<void> selectImage(XFile imageFile) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    await _saveImageAnswer(q, imageFile); // Use the new method
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
        currentGroupIndex.value < 0 ||
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
  /// Recalculates and updates the progress for all groups.
  void _updateProgresses() {
    if (generatedQuestionGroups.isEmpty) {
      if (groupProgresses.isNotEmpty) groupProgresses.clear();
      return;
    }

    final newProgresses = List.generate(
      generatedQuestionGroups.length,
          (index) => _computeGroupProgress(index),
      growable: false,
    );

    // When onboarding is fully completed, ensure all progresses are 1.0
    if (isFinished) {
      for (int i = 0; i < newProgresses.length; i++) {
        newProgresses[i] = 1.0;
      }
    }

    groupProgresses.assignAll(newProgresses);
  }

  // -------------- Per-group progress (for section UIs) --------------
  /// Computes progress for a single group with more robust logic.
  double _computeGroupProgress(int groupIndex) {
    if (groupIndex < 0 || groupIndex >= generatedQuestionGroups.length) {
      return 0.0;
    }

    // Groups before the current one are considered 100% complete.
    if (currentGroupIndex.value > groupIndex) {
      return 1.0;
    }

    final activeQs = _activeQuestionsForGroup(groupIndex);
    if (activeQs.isEmpty) return 1.0; // An empty group is considered complete.

    // If we are at the end of the current group (awaiting confirmation),
    // it's also considered 100% complete.
    if (isAwaitingGroupConfirmation.value &&
        currentGroupIndex.value == groupIndex) {
      return 1.0;
    }

    // For the current or future groups, calculate based on actual answers.
    final answered = _answeredCount(activeQs);
    return (answered / activeQs.length).clamp(0.0, 1.0);
  }
}