import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/network/network_error/api_error_handler.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/trainee_onboarding/repository/traineer_onboarding_qa_repository.dart';
import 'package:icon/app/modules/trainee_onboarding/services/location_service.dart';
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

  // --------------- Service --------------------
  final LocationService _locationService = Get.find<LocationService>();

  LocationService get locationService => _locationService;
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

  // --------------- Answers ---------------
  final Map<int, String> answers = {};

  /// True when the UI should show the "Continue" and "Skip" buttons.
  bool get showGroupContinuationButtons => isAwaitingGroupConfirmation.value;
  final RxBool isOtherOptionSelected = false.obs;
  final RxBool enableReminderTimePicker = false.obs;

  final RxSet<String> selectedBodyParts = <String>{}.obs;

  //-------------------- QA Stepper --------------------
  /// Holds the progress (0.0 to 1.0) for each question group.
  final RxList<double> groupProgresses = <double>[].obs;

  RxInt traineeId = 1.obs;

  final Map<String, Map<String, String>> groupMetadataMap = {
    'personal': {
      'displayName': 'Personal Information',
      'intro': "Great! Now for a bit about your Personal data.",
    },
    'goals': {
      'displayName': 'Goals & Activity',
      'intro': "Let's talk about your goals and activity levels.",
    },
    'nutrition': {
      'displayName': 'Nutrition',
      'intro': 'Now, a few questions about your nutrition habits.',
    },
    'recovery': {
      'displayName': 'Health & Recovery',
      'intro': "Finally, let's talk about your health and recovery.",
    },
    'body_profile': {
      'displayName': 'Body Profile',
      'intro':
          "Excellent! Let's get your body profile details to track progress.",
      'conclusion': "That's everything I need to know. Thanks for sharing!",
    },
    'activity': {
      'displayName': 'Activity Levels',
      'intro': "Let's discuss your typical activity levels.",
      'conclusion': "Thanks for the info on your activity levels.",
    },
    'general': {
      'displayName': 'General Questions',
      'intro': "Great! Let's get started with some general questions.",
      'conclusion': "Thanks for providing the details.",
    },
  };

  @override
  void onInit() {
    super.onInit();
    // Init servives
    _locationService.attach(this);
    // Progress updates are now tied to the dynamic groups
    currentGroupIndex.listen((_) => _updateProgresses());
    currentQuestionIndexInGroup.listen((_) => _updateProgresses());
    isAwaitingGroupConfirmation.listen((_) => _updateProgresses());
  }

  @override
  void onReady() {
    super.onReady();
    // listener that scrolls to the bottom whenever a new message is added.
    messages.listen((_) {
      _scrollToBottom();
    });

    // scroll to the bottom whenever typing
    ever(inputText, (value) {
      // Scroll to the bottom if the user is typing and the view is not already there.
      if (value.isNotEmpty &&
          pageController.hasClients &&
          pageController.position.extentAfter > 0) {
        _scrollToBottom();
      }
    });

    start();
  }

  @override
  void onClose() {
    textController.removeListener(_scrollToBottom);
    textController.dispose();
    pageController.dispose();
    super.onClose();
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
        if (kDebugMode) {
          throw Exception(error);
        }
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

    // Map to store questions grouped by their raw group_name from the API.
    final Map<String, List<TraineeQuestionData>> questionsByRawGroup = {};
    // Map to store the lowest index encountered for each group, used for ordering.
    final Map<String, double> groupFirstIndex = {};

    // Populate questionsByRawGroup and groupFirstIndex
    for (final question in allQuestions) {
      final String rawGroupName = question.groupName
          .toLowerCase(); // Ensure consistency
      final double questionIndex = double.tryParse(question.index) ?? 0.0;

      (questionsByRawGroup[rawGroupName] ??= []).add(question);

      if (!groupFirstIndex.containsKey(rawGroupName) ||
          questionIndex < groupFirstIndex[rawGroupName]!) {
        groupFirstIndex[rawGroupName] = questionIndex;
      }
    }

    // Determine the dynamic order of groups based on their first question's index.
    final List<String> dynamicGroupOrderKeys = groupFirstIndex.keys.toList()
      ..sort((a, b) => groupFirstIndex[a]!.compareTo(groupFirstIndex[b]!));

    final List<QuestionGroup> newGroups = [];
    for (final rawGroupName in dynamicGroupOrderKeys) {
      final groupQuestionsData = questionsByRawGroup[rawGroupName];

      if (groupQuestionsData != null && groupQuestionsData.isNotEmpty) {
        final groupQAItems = groupQuestionsData
            .map((data) => _mapDataToQAItem(data))
            .toList();

        final metadata = groupMetadataMap[rawGroupName];
        if (metadata != null) {
          newGroups.add(
            QuestionGroup(
              name:
                  metadata['displayName']!, // Use the display name from metadata
              introduction: metadata['intro']!,
              conclusion: metadata['conclusion'], // This can be null
              questions: groupQAItems,
            ),
          );
        } else {
          // Handle groups from API that don't have predefined metadata
          "Warning: No metadata found for group '$rawGroupName'. Using raw name and no intro/conclusion."
              .log();
          newGroups.add(
            QuestionGroup(
              name: rawGroupName
                  .capitalizeFirst!, // Capitalize for display if no metadata
              introduction: '', // No intro
              conclusion: null, // No conclusion
              questions: groupQAItems,
            ),
          );
        }
      }
    }

    if (newGroups.isEmpty) {
      "Warning: No question groups were created. Check the incoming 'group_name' values from the API."
          .log();
    }

    generatedQuestionGroups.assignAll(newGroups);
    // Initialize progress for each dynamically created group.
    groupProgresses.assignAll(List.filled(newGroups.length, 0.0));
  }

  /// Maps a [TraineeQuestionData] object from the API to a [QAItem] used by the chat UI.
  QAItem _mapDataToQAItem(TraineeQuestionData data) {
    return QAItem(
      id: data.id ?? 1,
      question: data.text,
      type: data.type,
      isLastInGroup: data.isLastInGroup,
      questionFieldName: data.fieldName,
      metadata: data.metadata,
      hint: null,
      canSkip: data.isOptional,
    );
  }

  Future<void> continueToNextGroup() async {
    if (!isAwaitingGroupConfirmation.value) return;
    isAwaitingGroupConfirmation.value = false;

    currentGroupIndex.value++;
    currentQuestionIndexInGroup.value = 0;
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
    _fetchAndSetupQuestions();
  }

  void start() async {
    // Reset all state for a fresh start
    messages.clear();
    answers.clear();
    userEmail.value = '';
    hasAgreedToInitialTerms.value = false;
    currentGroupIndex.value = 0;
    currentQuestionIndexInGroup.value = 0;
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
      Future.delayed(
        Duration(seconds: 1),
        () => Get.toNamed(
          Routes.TRAINEE_FITNESS_REPORT_GENERATION,
          arguments: traineeId.value,
          // onboardingJson,
        ),
      );

      "Proceeding to fitness report with data: $onboardingJson".log();
    } catch (e) {
      CustomToast.showErrorToast('Error saving data: $e');
    }
  }

  Future<void> _botSay(String text) async {
    isTyping.value = true;
    _scrollToBottom(); // Scroll down to show the typing indicator
    final delayMs = (text.length * 25).clamp(400, 1500);
    await Future.delayed(Duration(milliseconds: delayMs));

    messages.add(
      ChatMessage(
        from: Sender.bot,
        text: text,
        status: MessageStatus.delivered,
      ),
    );
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

  Future<void> _askNext() async {
    if (onboardingPhase.value != OnboardingPhase.askingQuestions) return;
    if (isAwaitingGroupConfirmation.value) return;

    // Defensive index checks
    if (generatedQuestionGroups.isEmpty) {
      await _completeOnboarding();
      return;
    }
    if (currentGroupIndex.value < 0 ||
        currentGroupIndex.value >= generatedQuestionGroups.length) {
      currentGroupIndex.value = 0;
    }
    if (currentQuestionIndexInGroup.value < 0) {
      currentQuestionIndexInGroup.value = 0;
    }

    // If we've finished all questions in the current group, move to next group
    if (currentQuestionIndexInGroup.value >=
        generatedQuestionGroups[currentGroupIndex.value].questions.length) {
      final finishedGroup = generatedQuestionGroups[currentGroupIndex.value];
      if (finishedGroup.conclusion != null) {
        await _botSay(finishedGroup.conclusion!);
      }
      if (currentGroupIndex.value >= generatedQuestionGroups.length - 1) {
        await _completeOnboarding();
        return;
      }
      isAwaitingGroupConfirmation.value = true;
      final remainingGroups = generatedQuestionGroups.sublist(
        currentGroupIndex.value + 1,
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

    final currentQuestion = generatedQuestionGroups[currentGroupIndex.value]
        .questions[currentQuestionIndexInGroup.value];

    // If last question in group, show personalized comment
    if (currentQuestion.isLastInGroup) {
      final currentQuestionGroup =
          generatedQuestionGroups[currentGroupIndex.value];
      String personalizedComment = await _onboardingQARepository
          .getPersonalizedOnboardingGroupComment(
            1,
            groupMetadataMap.entries
                .firstWhere(
                  (e) => e.value["displayName"] == currentQuestionGroup.name,
                )
                .key,
          );
      await _botSay(personalizedComment);
    }

    // If new group, show introduction
    final bool isNewGroup = currentQuestionIndexInGroup.value == 0;
    if (isNewGroup) {
      await _botSay(
        generatedQuestionGroups[currentGroupIndex.value].introduction,
      );
    }

    await _botSay(currentQuestion.question);
    _updateProgresses();
  }

  /// Scrolls the chat view to the bottom to show the latest message.
  void _scrollToBottom() {
    // A short delay ensures that the UI has had time to update before scrolling.
    Future.delayed(const Duration(milliseconds: 100), () {
      if (pageController.hasClients) {
        pageController.animateTo(
          pageController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void onReminder(String option) {
    if (!_canAnswer) return;

    if (option.contains('Yes')) {
      final userMessage = ChatMessage(
        from: Sender.user,
        text: option,
        status: MessageStatus.delivered,
      );
      messages.add(userMessage);
      return;
    }

    send(option);
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

      userMessage.updateStatus(
        MessageStatus.delivered,
      ); // Mark as delivered on success
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

    if (q.type.name == "number" && int.tryParse(value) == null) {
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
    final userMessage = ChatMessage(
      from: Sender.user,
      text: value,
      status: MessageStatus.pending,
    );
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
    QAItem q,
    String answerValue,
    ChatMessage userMessage,
  ) async {
    messages.add(userMessage);

    answers[q.id] = answerValue;
    _scrollToBottom();
    _updateProgresses();

    // Handle Other option selection
    if (answerValue.contains('Other')) {
      isOtherOptionSelected.value = true;
      return;
    } else {
      isOtherOptionSelected.value = false;
    }

    bool success = false;
    success = await _sendMessage(userMessage);

    // If either the update or the fallback send was successful, move to the next question.
    // Otherwise, stay on the current question; the message status will show 'failed'.
    if (success) {
      currentQuestionIndexInGroup.value++;
      await _askNext();
    }
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

      final candidate = generatedQuestionGroups[targetGroupIndex]
          .questions[targetQuestionIndex];

      if (!_shouldSkipQuestion(candidate)) break;
    }

    if (targetGroupIndex < 0) {
      start();
      return;
    }

    final q = generatedQuestionGroups[targetGroupIndex]
        .questions[targetQuestionIndex];
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

  void selectDate(String date) async {
    if (!_canAnswer) return;
    final q = currentQuestion!;
    // final formattedDate =
    //     "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    await _saveUserAnswer(q, date);
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
    // If onboarding is finished, the progress of the last step is 1.0.
    if (isFinished) return 1.0;

    final groupIndex = currentGroupIndex.value;

    // Before starting or if groups are not set up, progress is 0.
    if (groupIndex < 0 || groupIndex >= generatedQuestionGroups.length) {
      return 0.0;
    }

    return _computeGroupProgress(groupIndex);
  }

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

  bool get isCurrentChoice => currentQuestion?.type.name == "select_multiple";

  bool get isCurrentDate => currentQuestion?.type.name == "date";

  bool get isCurrentTime => currentQuestion?.type.name == "time";

  bool get isCurrentHeight => currentQuestion?.type.name == "height";

  bool get isCurrentWeight => currentQuestion?.type.name == "weight";

  bool get isCurrentImage => currentQuestion?.type.name == "image";

  bool get isCurrentLocation => currentQuestion?.type.name == "location";

  bool get isCurrentPhoneNumber => currentQuestion?.type.name == "phone_number";

  bool get isCurrentReminder => currentQuestion?.type.name == "reminder";

  bool get isCurrentBodyPart => currentQuestion?.type.name == "body_parts";

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
