import 'dart:async';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/data/local/preference/store/trainee_data_store.dart';
import 'package:icon/app/routes/app_pages.dart';
import '../../../base/widgets/custom_toast.dart';
import '../../trainee_onboarding/models/trainee_profile_create_model.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';

class ProfileCreateAnimationController extends BaseController {
  final TraineeOnboardingRepository _repo = Get.find(tag: (TraineeOnboardingRepository).toString());
  final RxBool _isProcessing = false.obs;

  /// Public method called by the View to start the profile creation process.
  /// This prevents duplicate API calls.
  void startProfileCreation() {
    if (_isProcessing.isTrue) return;
    _createTraineeProfile();
  }

  /// Manages the API calls and guarantees navigation to the home screen.
  Future<void> _createTraineeProfile() async {
    _isProcessing.value = true;
    TraineeProfileCreateModel? traineeProfile = TraineeDataStore.to.traineeModelValue;

    if (traineeProfile == null) {
      logger.e("FATAL: No trainee data found. Navigating home anyway.");
      // If there's no data, we can't make API calls, so just navigate home.
      Get.offAllNamed(Routes.HOME);
      return;
    }

    try {
      // Use Future.wait to run API calls in parallel.
      // `settle` ensures the Future completes even if some calls fail.
      final results = await Future.wait([
        _createProfile(traineeProfile),
        _createPreference(traineeProfile),
      ].map((f) => f.reflect()), // .reflect() helps settle the futures
      );

      // Optional: Check results if needed for logging
      // --- FIX: Access the record's `error` property to check for success ---
      final successfulCalls = results.where((res) => res.error == null).length;
      'Process complete. Successful calls: $successfulCalls/${results.length}'.log();
      if (successfulCalls == results.length) {
        CustomToast.showSuccessToast('Profile created successfully!');
      } else {
        CustomToast.showErrorToast('Could not save all profile details.');
      }

    } catch (e) {
      // This catch block might be hit if Future.wait itself has an issue, which is rare.
      logger.e("An unexpected error occurred during profile creation: ${e.toString()}");
      CustomToast.showErrorToast("An unexpected error occurred.");
    } finally {
      // --- GUARANTEED NAVIGATION ---
      // This block will always execute, whether the API calls succeeded or failed.
      'Navigating to home screen...'.log();
      _isProcessing.value = false;
      Get.offAllNamed(Routes.HOME);
    }
  }

  /// Creates the user profile. Returns a Future.
  Future<void> _createProfile(TraineeProfileCreateModel profile) {
    final model = {
      "bio": profile.description ?? '',
      "date_of_birth": profile.dateOfBirth ?? '',
      "phone_number": "12345678",
      "full_address": profile.fullAddress ?? '',
      "country": profile.country ?? '',
      "city": profile.city ?? '',
      "gender": profile.gender ?? '',
    };
    return _repo.createTraineeProfile(model);
  }

  /// Creates the user preferences. Returns a Future.
  Future<void> _createPreference(TraineeProfileCreateModel profile) {
    final model = {
      "fitness_experience": profile.experience ?? '',
      "accountability_partner": profile.partner ?? '',
      "training_location": profile.trainingLocation ?? '',
      "equipment_access": profile.equipmentAccess ?? '',
      "preferred_training_style": profile.preferredTrainingStyle ?? '',
      "days_per_week": profile.daysPerWeek ?? '',
      "session_length": profile.sessionLength ?? '',
      "training_intensity": profile.trainingIntensity ?? '',
      "preferred_time_of_day": profile.preferredTimeOfDay ?? '',
      "training_reminder": profile.trainingReminder ?? '',
    };
    return _repo.createTraineePreferences(model);
  }
}

// Extension to help with Future.wait and error handling
extension FutureReflect<T> on Future<T> {
  // The record is defined with named properties: `value` and `error`
  Future<({T? value, Object? error})> reflect() {
    return then((value) => (value: value, error: null))
        .catchError((error) => (value: null, error: error));
  }
}
