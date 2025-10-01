import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../base/widgets/custom_toast.dart';
import '../models/trainee_profile_create_model.dart';
import '../repository/trainee_onboarding_repository.dart';

class TraineeOnboardingController extends GetxController {
  // ........... Text Controllers ...............
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController addressCtr = TextEditingController();
  final TextEditingController cityCtr = TextEditingController();
  final TextEditingController countryCtr = TextEditingController();
  final TextEditingController descriptionCtr = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxString selectedGender = ''.obs;
  final RxString fitnessExperience = ''.obs;
  final RxString selectedPartner = ''.obs;
  final RxBool isButtonLoading = false.obs;

  //........... Repository ...............
  final TraineeOnboardingRepository _repository = Get.find(
    tag: (TraineeOnboardingRepository).toString(),
  );

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate; // This is now type-safe
    }
  }

  void onDoneButtonPressed() {
    // check all are selected
    if (nameCtr.text.isEmpty ||
        addressCtr.text.isEmpty ||
        cityCtr.text.isEmpty ||
        countryCtr.text.isEmpty ||
        selectedGender.value.isEmpty ||
        selectedDate.value == null) {
      CustomToast.showErrorToast('Please fill all fields');
      return;
    }

    isButtonLoading(true);

    // Store the data to the TraineeProfileCreateModel
    final TraineeProfileCreateModel traineeProfileCreateModel =
        TraineeProfileCreateModel(
          bio: descriptionCtr.text,
          dateOfBirth: selectedDate.value,
          phoneNumber: '1234567890',
          fullAddress: addressCtr.text,
          country: countryCtr.text,
          city: cityCtr.text,
          gender: selectedGender.value,
          experience: fitnessExperience.value,
          partner: selectedPartner.value,
          description: descriptionCtr.text,
          trainingLocation: 'Home',
          equipmentAccess: '',
          preferredTrainingStyle: '',
          daysPerWeek: null,
          sessionLength: '',
          trainingIntensity: null,
          preferredTimeOfDay: '',
          trainingReminder: null,
        );
    // Store to local DB
    _repository
        .storeTraineeProfile(traineeProfileCreateModel)
        .then(
          (_) {
            Get.toNamed(Routes.LOGIN);
            CustomToast.showToast(message: 'Please Login to Create Profile');
            isButtonLoading(false);
          },
          onError: (error) {
            CustomToast.showErrorToast('Something went wrong!');
            isButtonLoading(false);
          },
        );
  }
}
