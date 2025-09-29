import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  var obscurePassword = true.obs;
  var rememberMe = false.obs;

  // TextInput validation error
  var passwordError = RxnString();
  var emailError = RxnString();

  @override
  void onClose() {
    emailCtr.dispose();
    passwordCtr.dispose();
    super.onClose();
  }

  // Email validation logic
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

  void onLoginButtonPressed() {
    // Trigger validation for both email and password
    emailError.value = validateEmail(emailCtr.text);
    passwordError.value = validatePassword(passwordCtr.text);

    // Only proceed with login if there are no errors
    if (emailError.value == null && passwordError.value == null) {
      // Perform login action
      Get.snackbar("Login", "Login attempt for: ${emailCtr.text}"); // Example
    }
  }
}
