import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/modules/register/repository/registration_repository.dart';

class RegisterController extends GetxController {
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  final nameCtr = TextEditingController();
  var obscurePassword = true.obs;
  var agreeToService = false.obs;

  // TextInput validation error
  var passwordError = RxnString();
  var emailError = RxnString();
  var nameError = RxnString();
  var isLoading = false.obs;

  // ............ Repository .............
  final RegistrationRepository _registrationRepository = Get.find(
    tag: (RegistrationRepository).toString(),
  );

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    // Basic email format validation using a regular expression
    // This is a common, though not exhaustive, regex for email validation.
    // For stricter validation, you might consider a more complex regex or a package.
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null; // Return null if validation passes
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  void onRegisterButtonPressed() {
    // Handle login loading
    if (isLoading.isTrue) return;

    // Trigger validation for both email and password
    emailError.value = validateEmail(emailCtr.text);
    passwordError.value = validatePassword(passwordCtr.text);
    nameError.value = validateName(emailCtr.text);

    // Only proceed with login if there are no errors
    if (emailError.value == null &&
        passwordError.value == null &&
        nameError.value == null) {
      isLoading(true);

      final requestBody = {
        "username": nameCtr.text,
        "email": emailCtr.text,
        "password": passwordCtr.text,
      };

      _registrationRepository
          .onRegister(requestBody)
          .then(
            (response) {
              Get.back();
              CustomToast.showSuccessToast(
                response.message ?? "User registered successfully",
              );
            },
            onError: (e) {
              isLoading.value = false;
              if(e is ApiException){
                CustomToast.showErrorToast(e.description);
                return;
              }
              CustomToast.showErrorToast('An unexpected error occurred');
            },
          );
    }
  }
}
