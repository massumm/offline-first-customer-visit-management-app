import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/basic_types.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/utils/app_validators.dart';

class TraineeFitnessReportGenerationController extends BaseController {
  //TODO: Implement TraineeFitnessReportGenerationController

  final count = 0.obs;

 final TextEditingController emailCtr = TextEditingController();

  var emailError = RxnString() ;
  final isValidEmail = RxBool(false);
  final isLoading = RxBool(false);

  @override
  void onClose() {
    emailCtr.dispose();
    super.onClose();
  }
  Future<void> onSubmitButtonPressed() async {
    if (isValidEmail.value) {
      isLoading.value = true; // Set loading to true
      try {
        // Simulate an asynchronous operation
        await Future.delayed(const Duration(seconds: 2));
        print('Email submitted: ${emailCtr.text}');
        // Navigate or perform next action
        // Get.toNamed(Routes.SOME_NEXT_SCREEN);
      } catch (e) {
        print('Error submitting email: $e');
        // Handle error, e.g., show a snackbar
      } finally {
        isLoading.value = false; // Set loading to false regardless of success/failure
      }
    }
  }
  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);
  }
}
