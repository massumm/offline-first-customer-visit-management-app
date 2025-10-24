import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/utils/app_validators.dart';

import '../views/saving_view.dart';

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
       Get.to(() => SavingView());
    }
  }
  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);

    if(emailError.value == null){
      isValidEmail(true);
    }
  }
}
