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
import '../../../data/local/preference/store/user_store.dart';
import '../../login/models/login_response_model.dart';
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

  // --- UI State for the initial email form ---
  final TextEditingController emailCtr = TextEditingController();
  var emailError = RxnString();
  final isSubmitBtnEnable = RxBool(false);
  final RxBool onEmailLoading = false.obs;

  final RxBool isValidEmail = true.obs;

  // ---------------Progress Loading Effect State ---------------
  // --- UI State for the Saving/Progress View ---
  final progress = 0.0.obs;
  var enableApiProgressState = false.obs; // Triggers navigation to SavingView

  // --- New properties for error handling in SavingView ---
  final hasError = false.obs;

  final RxString errorMessage =
      'An unexpected error occurred. Please try again.'.obs;

  @override
  void onClose() {
    emailCtr.dispose();
    super.onClose();
  }

  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);
    isSubmitBtnEnable.value = emailError.value == null;
  }

  /// Handles the initial email submission.
  Future<void> onSubmitButtonPressed() async {
    if (isSubmitBtnEnable.value == false) return;

    isSubmitBtnEnable(false);
    onEmailLoading(true);

    try {
      final response = await _onboardingAuthRepository.registerEmail({
        'email': emailCtr.text,
      });

      await _storeUserTokenAndStartReport(response);
    } catch (e) {
      isSubmitBtnEnable(true);
      onEmailLoading(false);

      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      } else {
        CustomToast.showErrorToast(
          "An unexpected error occurred. Please try again.",
        );
        "Error on submit: ${e.toString()}".log();
      }
    }
  }

  /// Saves the user token, then triggers the report generation process.
  Future<void> _storeUserTokenAndStartReport(
      LoginResponseModel response,
      ) async {
    try {
      await UserStore.to.saveProfileAndToken(response);
      enableApiProgressState(true);
      onEmailLoading(false);
      await _createTraineeReport();
    } catch (e) {
      "Failed to store user token: ${e.toString()}".log();
      CustomToast.showErrorToast("Failed to save session. Please try again.");
      isSubmitBtnEnable(true);
      enableApiProgressState(false);
    }
  }

  void retryReportGeneration() {
    // Reset state before retrying
    hasError(false);
    progress(0.0);
    errorMessage('An unexpected error occurred. Please try again.');
    _createTraineeReport();
  }

  Future<void> _createTraineeReport() async {
    try {

      if (hasError.value) hasError(false);

      final onboardingJson = TraineeDataStore.to.onboardingDataValue;
      final answers = onboardingJson?['answers'] as Map<String, dynamic>?;

      if (answers == null) {
        throw ApiException(
          message:
          "Could not find your onboarding data. Please restart the process.",
          httpCode: 500,
          status: '',
        );
      }

      // Each step updates the progress and can throw an exception on failure.
      progress.value = 0.1;
      await _createProfile(answers);
      progress.value = 0.2;

      await _createPreference(answers);
      progress.value = 0.4;

      await _createPreferenceGoals(answers);
      progress.value = 0.6;

      await _createPreferenceActivity(answers);
      progress.value = 0.7;

      await _createPreferenceNutrition(answers);
      progress.value = 0.85;

      await _createPreferenceRecovery(answers);
      progress.value = 1.0; // Complete

      // If all steps succeed, navigate to the next screen.
      await Get.offAllNamed(Routes.FITNESS_REPORT);
    } on ApiException catch (e) {
      errorMessage(
        e.message,
      );
      hasError(true);
      "API Error during report generation: ${e.description}".log();
    } catch (e) {
      errorMessage(
        'A network error occurred. Please check your connection and try again.',
      );
      hasError(true);
      "Unexpected error during report generation: ${e.toString()}".log();
    }
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
    try {
      return await _onboardingRepository.createTraineeProfile(model);
    } on ApiException catch (e) {
      "API Error creating profile: ${e.description}".log();
      rethrow;
    } catch (e) {
      "Unexpected error in _createProfile: ${e.toString()}".log();
      throw ApiException(
        message: "Failed to create your profile. Please try again.",
        httpCode: 500,
        status: '',
      );
    }
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
      "days_per_week": answers['workout_frequency'] ?? 0,
      "session_length": answers['session_duration'] ?? '',
      "training_intensity": answers['session_intensity'] ?? 0,
      "preferred_time_of_day": answers['preferred_training_time'] ?? '',
      "training_reminder": answers['set_reminder'] ?? false,
    };
    try {
      return await _onboardingRepository.createTraineePreferences(model);
    } on ApiException catch (e) {
      "API Error creating preferences: ${e.description}".log();
      rethrow;
    } catch (e) {
      "Unexpected error in _createPreference: ${e.toString()}".log();
      throw ApiException(
        message: "Failed to save your preferences. Please try again.",
        httpCode: 500,
        status: '',
      );
    }
  }

  Future<Map<String, dynamic>> _createPreferenceGoals(
      Map<String, dynamic> answers,
      ) async {
    final model = {
      "trainee_goal": 0,
      "description": "string",
      "event_date": "2019-08-24",
      "is_active": true,
    };
    try {
      return await _onboardingRepository.createTraineePreferenceGoals(model);
    } on ApiException catch (e) {
      "API Error creating preference goals: ${e.description}".log();
      rethrow;
    } catch (e) {
      "Unexpected error in _createPreferenceGoals: ${e.toString()}".log();
      throw ApiException(
        message: "Failed to save your goals. Please try again.",
        httpCode: 500,
        status: '',
      );
    }
  }

  Future<void> _createPreferenceActivity(Map<String, dynamic> answers) async {
    return Future.value();
  }

  Future<Map<String, dynamic>> _createPreferenceNutrition(
      Map<String, dynamic> answers,
      ) async {
    final model = {
      "trainee_profile": 0,
      "food": {"name": "string"},
      "food_name": "string",
      "relationship": "liked",
      "reason": "string",
      "allergy_name": "string",
      "reaction_description": "string",
      "severity_level": 32767,
    };
    try {
      return await _onboardingRepository.createTraineePreferenceNutrition(
        model,
      );
    } on ApiException catch (e) {
      "API Error creating preference nutrition: ${e.description}".log();
      rethrow;
    } catch (e) {
      "Unexpected error in _createPreferenceNutrition: ${e.toString()}".log();
      throw ApiException(
        message: "Failed to save nutrition preferences. Please try again.",
        httpCode: 500,
        status: '',
      );
    }
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
    try {
      return await _onboardingRepository.createTraineePreferenceRecovery(model);
    } on ApiException catch (e) {
      "API Error creating preference recovery: ${e.description}".log();
      rethrow;
    } catch (e) {
      "Unexpected error in _createPreferenceRecovery: ${e.toString()}".log();
      throw ApiException(
        message: "Failed to save recovery preferences. Please try again.",
        httpCode: 500,
        status: '',
      );
    }
  }
}