import 'dart:async';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/data/local/preference/store/trainee_data_store.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';


class ProfileCreateAnimationController extends BaseController {
  final TraineeOnboardingRepository _repo = Get.find(
    tag: (TraineeOnboardingRepository).toString(),
  );
  final RxBool _isProcessing = false.obs;

  late final Future<LottieComposition> composition;

  /// Public method called by the View to start the profile creation process.
  /// This prevents duplicate API calls.

  @override
  void onInit() {
    composition = AssetLottie(Assets.jsonsProfileLoading).load();
    startProfileCreation();
    super.onInit();
  }
  void startProfileCreation() {
    if (_isProcessing.isTrue) return;
    _createTraineeProfile();
  }

  /// Manages the API calls and guarantees navigation to the home screen.
  Future<void> _createTraineeProfile() async {
    _isProcessing.value = true;
    final onboardingJson = TraineeDataStore.to.onboardingDataValue;

    // Safely get the answers map
    final answers = onboardingJson?['answers'] as Map<String, dynamic>?;

    if (answers == null) {
      logger.e("FATAL: No onboarding answers found. Navigating home.");
      // If there's no data, we can't make API calls, so just navigate home.
      Get.offAllNamed(Routes.HOME);
      return;
    }

    try {
      // Use Future.wait to run API calls in parallel.
      // `reflect()` ensures the Future completes even if some calls fail.
      final results = await Future.wait(
        [
          _createProfile(answers),
          _createPreference(answers),
        ].map((f) => f.reflect()), // .reflect() helps settle the futures
      );

      final successfulCalls = results.where((res) => res.error == null).length;
      'Process complete. Successful calls: $successfulCalls/${results.length}'
          .log();
      if (successfulCalls == results.length) {
        CustomToast.showSuccessToast('Profile created successfully!');
      } else {
        CustomToast.showErrorToast('Could not save all profile details.');
      }
    } catch (e) {
      // This catch block might be hit if Future.wait itself has an issue
      logger.e(
        "An unexpected error occurred during profile creation: ${e.toString()}",
      );
    } finally {
      // --- GUARANTEED NAVIGATION ---
      // This block will always execute, whether the API calls succeeded or failed.
      'Navigating to home screen...'.log();
      _isProcessing.value = false;
      Get.offAllNamed(Routes.HOME);
    }
  }

  /// Creates the user profile by mapping answers to the API model.
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
    return _repo.createTraineeProfile(model);
  }

  /// Creates the user preferences by mapping answers to the API model.
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
    return _repo.createTraineePreferences(model);
  }

  @override
  void onClose() {
    // Clean up the stored onboarding data after processing is complete.
    TraineeDataStore.to.cleanOnboardingData();
    super.onClose();
  }
}

// Extension to help with Future.wait and error handling
extension FutureReflect<T> on Future<T> {
  // The record is defined with named properties: `value` and `error`
  Future<({T? value, Object? error})> reflect() {
    return then(
          (value) => (value: value, error: null),
    ).catchError((error) => (value: null, error: error));
  }
}