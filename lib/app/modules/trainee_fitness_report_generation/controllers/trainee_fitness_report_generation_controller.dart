import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/utils/app_validators.dart';

class TraineeFitnessReportGenerationController extends BaseController {

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
      isLoading.value = true;
      try {

        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        'Error submitting email: $e'.log();
      } finally {
        isLoading.value = false;
      }
    }
  }
  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);

    if(emailError.value == null){
      isValidEmail(true);
    }
  }
}
