import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/widgets/custom_toast.dart';
import '../models/trainee_profile_create_model.dart';
import '../repository/trainee_onboarding_repository.dart';

class TraineeOnboardingController extends GetxController {
 // ........... Text Controllers ...............
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController addressCtr = TextEditingController();
  final TextEditingController cityCtr = TextEditingController();
  final TextEditingController countryCtr = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxString selectedGender = ''.obs;
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
        selectedDate.value == null){
      CustomToast.showErrorToast('Please fill all fields');
      return;
    }

    isButtonLoading(true);

    final model = TraineeProfileCreateModel(
      bio: nameCtr.text,
      fullAddress: addressCtr.text,
      city: cityCtr.text,
      country: countryCtr.text,
      gender: selectedGender.value,
      dateOfBirth: selectedDate.value,
      phoneNumber: '0123456789',
    );

    _repository.createTraineeProfile(model).then((response){
      isButtonLoading(false);
      CustomToast.showSuccessToast('Profile created successfully');
    }, onError: (error){
      isButtonLoading(false);
      CustomToast.showErrorToast('An unexpected error occurred');
    });

  }



}
