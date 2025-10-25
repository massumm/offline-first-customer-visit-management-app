import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/utils/app_validators.dart';

import '../../../base/repository/trainee_onboarding_auth_repo/trainee_onboarding_auth_repository.dart';
import '../../../data/local/preference/store/trainee_data_store.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';

class TraineeFitnessReportGenerationController extends BaseController {
  final TraineeOnboardingRepository _onboardingRepository = Get.find(
    tag: (TraineeOnboardingRepository).toString(),
  );

  final TraineeOnboardingAuthRepository _onboardingAuthRepository = Get.find(
    tag: (TraineeOnboardingAuthRepository).toString(),
  );

  final TextEditingController emailCtr = TextEditingController();
  var emailError = RxnString();

  final isSubmitBtnEnable = RxBool(false);

  final RxBool onEmailLoading = false.obs;

  // ---------------Progress Loading Effect State ---------------
  final progress = 0.0.obs;
  var enableApiProgressState = false.obs;


  @override
  void onInit() {
    super.onInit();
    // Simulate progress updates, e.g., from a backend call
    _simulateProgress();
  }

  @override
  void onClose() {
    emailCtr.dispose();
    super.onClose();
  }



  // You might also have a method to manually update progress if needed
  void updateProgress(double value) {
    progress.value = value.clamp(0.0, 1.0);
  }

  Future<void> onSubmitButtonPressed() async {
    if (isSubmitBtnEnable.value) {
      onEmailLoading(true);
      isSubmitBtnEnable(false); // Disable the button

      await _onboardingAuthRepository
          .registerEmail({'email': emailCtr.text})
          .then(
            (value) {
              enableApiProgressState(true);
              _createTraineeReport();
            },
            onError: (e) {
              isSubmitBtnEnable(true); // Enable the button
              if (e is ApiException) {
                 CustomToast.showErrorToast(e.description);
              }
            },
          )
          .whenComplete(() => onEmailLoading(false));
    }
  }

  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);

    if (emailError.value == null) {
      isSubmitBtnEnable(true);
    }
  }

  // -------------------- Progress Indicator Animations -----------
  void _simulateProgress() async {
    // This is just an example. In a real app, this would come from
    // actual data saving operations.
    await Future.delayed(const Duration(milliseconds: 500));
    progress.value = 0.1;
    await Future.delayed(const Duration(milliseconds: 800));
    progress.value = 0.3;
    await Future.delayed(const Duration(milliseconds: 1200));
    progress.value = 0.6;
    await Future.delayed(const Duration(milliseconds: 1000));
    progress.value = 0.85;
    await Future.delayed(const Duration(milliseconds: 700));
    progress.value = 1.0; // Complete
    // After completion, you might navigate to another screen
    // Get.offAllNamed('/report_complete');

    _createTraineeReport();
  }

  /// Gathers trainee data, creates their profile and preferences via API calls,
  /// and updates the progress indicator accordingly.
  Future<void> _createTraineeReport() async {
    Map<String, dynamic>? answers;
    try {
      final onboardingJson = TraineeDataStore.to.onboardingDataValue;
      answers = onboardingJson?['answers'] as Map<String, dynamic>?;
    } catch (e) {
      "Error on getting trainee data: ${e.toString()}".log();
      // Propagate a user-friendly error to be caught by the caller.
      // throw ApiException(message: "Failed to retrieve your answers. Please try again.", httpCode: null, status: '');
    }

    if (answers == null) {
      logger.e("FATAL: No onboarding answers found.");
      // If there's no data, we can't make API calls.
      // throw ApiException(message: "Could not find your onboarding data. Please restart the process.");
        return;
    }

    // Start the progress.
    progress.value = 0.2;

    // Create the user profile and update progress.
    await _createProfile(answers);
    progress.value = 0.6;

    // Create the user preferences and update progress.
    await _createPreference(answers);
    progress.value = 1.0; // Complete

    // After completion, you might navigate to another screen.
    // Get.offAllNamed('/report_complete');
  }

  Future<void> _createProfile(Map<String, dynamic> answers) {
    // Map the answers from the onboarding flow to the expected API keys.
    // Use the null-coalescing operator '??' to provide default values.
    final model = {
      "bio": answers['success_in_6_months'] ?? '',
      "date_of_birth": answers['dob'] ?? '',
      "phone_number": "12345678", // Placeholder as it's not in the questions
      "full_address": answers['address'] ?? '',
      "country": "", // Placeholder, as it's not a separate question
      "city": "", // Placeholder
      "gender": answers['gender'] ?? '',
    };
    return _onboardingRepository.createTraineeProfile(model);
  }

  Future<void> _createPreference(Map<String, dynamic> answers) {
    final model = {
      "fitness_experience": answers['fitness_experience'] ?? '',
      "accountability_partner": answers['accountability_partner'] ?? '',
      "training_location": answers['training_location'] ?? '',
      "equipment_access": answers['home_equipment'] ?? '',
      "preferred_training_style": answers['training_style'] ?? '',
      "days_per_week": answers['workout_frequency'] ?? '',
      "session_length": answers['session_duration'] ?? '',
      "training_intensity": answers['session_intensity'] ?? '',
      "preferred_time_of_day": answers['preferred_training_time'] ?? '',
      "training_reminder": answers['set_reminder'] ?? false,
    };
    return _onboardingRepository.createTraineePreferences(model);
  }


}
