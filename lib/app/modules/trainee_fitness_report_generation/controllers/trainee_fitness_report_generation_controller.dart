import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/utils/app_validators.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../base/repository/trainee_onboarding_auth_repo/trainee_onboarding_auth_repository.dart';
import '../../../data/local/preference/store/trainee_data_store.dart';
import '../../trainee_onboarding/models/trainee_preference_create_response_model.dart';
import '../../trainee_onboarding/models/trainee_profile_create_response_model.dart';
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
    // _simulateProgress();
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

  /// Gathers trainee data, creates their profile and preferences via API calls,
  /// and updates the progress indicator accordingly.
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
      throw ApiException(
        message: "Failed to retrieve your answers. Please try again.",
        httpCode: 500,
        status: '',
      );
    }

    if (answers == null) {
      logger.e("FATAL: No onboarding answers found.");
      // If there's no data, we can't make API calls.
      throw ApiException(
        message:
            "Could not find your onboarding data. Please restart the process.",
        httpCode: 500,
        status: '',
      );
    }

    // Start the progress.
    progress.value = 0.1;

    // Create the user profile and update progress.
    await _createProfile(answers);
    progress.value = 0.2;

    // Create the user preferences and update progress.
    await _createPreference(answers);
    progress.value = 0.4;

    // Create the user preference goals and update progress.
    await _createPreferenceGoals(answers);
    progress.value = 0.6;

    // Create the user preference activity and update progress.
    await _createPreferenceActivity(answers);
    progress.value = 0.7;

    // Create the user preference nutrition and update progress.
    await _createPreferenceNutrition(answers);
    progress.value = 0.85;

    // Create the user preference recovery and update progress.
    await _createPreferenceRecovery(answers);
    progress.value = 1.0; // Complete

    // After completion, you might navigate to another screen.
    Get.offAndToNamed(Routes.FITNESS_REPORT);
  }

  Future<TraineeProfileCreateResponseModel> _createProfile(
    Map<String, dynamic> answers,
  ) async {
    final model = {
      "bio": answers['success_in_6_months'] ?? '',
      "date_of_birth": answers['dob'] ?? '',
      "phone_number": "",
      "full_address": answers['address'] ?? '',
      "country": "",
      "city": "",
      "gender": answers['gender'] ?? '',
    };
    return await _onboardingRepository.createTraineeProfile(model);
  }

  Future<TraineePreferenceCreateResponseModel> _createPreference(
    Map<String, dynamic> answers,
  ) async {
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
    return await _onboardingRepository.createTraineePreferences(model);
  }

  Future<Map<String, dynamic>> _createPreferenceGoals(
    Map<String, dynamic> answers,
  ) async {
    final model = {
      "trainee_goal": 0, // TODO: ID?
      "description": "string",
      "event_date": "2019-08-24",
      "is_active": true,
    };

    return await _onboardingRepository.createTraineePreferenceGoals(model);
  }

  Future<void> _createPreferenceActivity(Map<String, dynamic> answers) async {
    return Future.value();
  }

  Future<Map<String, dynamic>> _createPreferenceNutrition(
    Map<String, dynamic> answers,
  ) async {
    final model = {
      "trainee_profile": 0, //TODO: ID?
      "food": {"name": "string"},
      "food_name": "string",
      "relationship": "liked",
      "reason": "string",
      "allergy_name": "string",
      "reaction_description": "string",
      "severity_level": 32767,
    };
    return await _onboardingRepository.createTraineePreferenceNutrition(model);
  }

  Future<Map<String, dynamic>> _createPreferenceRecovery(
    Map<String, dynamic> answers,
  ) async {
    final model = {
      "average_sleep_hours_per_night": 0,
      "desired_sleep_hours_per_night": 0,
      "water_intake_liters_per_day": 0,
      "stress_management_techniques": "string",
      "recovery_days_per_week": 32767,
      "sleep_quality": "poor",
      "daily_energy_level": "low",
      "current_stress_level": "low",
      "biggest_source_of_stress": "work",
      "biggest_source_of_stress_other": "string",
      "barrier_to_recovery_description": "string",
    };

    return await _onboardingRepository.createTraineePreferenceRecovery(model);
  }
}
