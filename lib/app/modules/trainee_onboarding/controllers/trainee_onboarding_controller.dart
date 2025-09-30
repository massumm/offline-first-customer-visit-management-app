import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TraineeOnboardingController extends GetxController {
 // ........... Text Controllers ...............
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController addressCtr = TextEditingController();
  final TextEditingController cityCtr = TextEditingController();
  final TextEditingController countryCtr = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxString selectedGender = ''.obs;

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

}
