import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/data/local/preference/store/trainee_data_store.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../base/widgets/custom_toast.dart';
import '../../trainee_onboarding/models/trainee_profile_create_model.dart';
import '../../trainee_onboarding/repository/trainee_onboarding_repository.dart';

class ProfileCreateAnimationController extends BaseController {
  TraineeProfileCreateModel? traineeProfile;

  final RxBool isLoading = false.obs;
  final TraineeOnboardingRepository _traineeOnboardingRepository = Get.find(
    tag: (TraineeOnboardingRepository).toString(),
  );

  @override
  void onInit() {
    super.onInit();

    _getTraineeModel();
  }

  @override
  void onReady() {
    super.onReady();

    ever(isLoading, (value){
      if(value == false){
        CustomToast.showSuccessToast('Profile created successfully!');
        Future.delayed(Duration(seconds: 1),
                () => Get.offAllNamed(Routes.PROFILE_CREATE_ANIMATION));
      }
    });
  }

  void _getTraineeModel() {
    try {
      traineeProfile = TraineeDataStore.to.traineeModel;
    } catch (e) {
      logger.e(e.toString());
    }

    _createTraineeProfile();
  }

  void _createTraineeProfile() {
    if (traineeProfile != null) {
      isLoading.value = true;
      Future.wait([
        _createProfile(),
        _createPreference(),
      ]).whenComplete(() => isLoading.value = false);
    }
  }

  Future<void> _createProfile() async {
    final model = {
      "bio": traineeProfile?.description ?? '',
      "date_of_birth": traineeProfile?.dateOfBirth ?? '',
      "phone_number": "12345678",
      "full_address": traineeProfile?.fullAddress ?? '',
      "country": traineeProfile?.country ?? '',
      "city": traineeProfile?.city ?? '',
      "gender": traineeProfile?.gender ?? '',
    };

    _traineeOnboardingRepository
        .createTraineeProfile(model)
        .then(
          (value) {
            'Profile created successfully'.log();
          },
          onError: (e) {
            logger.e(e.toString());
            CustomToast.showErrorToast(
              'An unexpected error occurred while creating profile',
            );
          },
        );
  }

  Future<void> _createPreference() async {
    final model = {
      "fitness_experience": traineeProfile?.experience ?? '',
      "accountability_partner": traineeProfile?.partner ?? '',
      "training_location": traineeProfile?.trainingLocation ?? '',
      "equipment_access": "none",
      "preferred_training_style": "general_training",
      "days_per_week": 32767,
      "session_length": "5_min",
      "training_intensity": 32767,
      "preferred_time_of_day": "morning",
      "training_reminder": true,
    };
  }
}
