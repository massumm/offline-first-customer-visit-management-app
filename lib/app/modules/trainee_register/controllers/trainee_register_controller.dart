import '../../../base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/modules/register/repository/registration_repository.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../core/theme/services/theme_service.dart';
import '../../../core/widgets/google_sign_in_api.dart';

class TraineeRegisterController extends BaseController {
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  final confirmPasswordCtr = TextEditingController();
  final nameCtr = TextEditingController();
  var obscurePassword = true.obs;
  var agreeToService = false.obs;

  // TextInput validation error
  var passwordError = RxnString();
  var emailError = RxnString();

  var confirmPasswordError = RxnString();
  var nameError = RxnString();
  var isLoading = false.obs;

  // .............Theme Data...........
  final ts = Get.find<ThemeService>();

  bool get isDarkTheme {
    final platformDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;

    return ts.themeMode == ThemeMode.dark ||
        (ts.themeMode == ThemeMode.system && platformDark);
  }

  // ............ Repository .............
  final RegistrationRepository _registrationRepository = Get.find(
    tag: (RegistrationRepository).toString(),
  );

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null; // Return null if validation passes
  }

  String? validatePassword(String? password, {String? email}) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (numericRegex.hasMatch(password)) {
      return "Password cannot consist entirely of digits.";
    }

    const commonPasswords = {
      '12345678',
      'password',
      '123456',
      '123456789',
      'qwerty',
      '111111',
      'p@ssword',
      'admin',
    };

    if (commonPasswords.contains(password.toLowerCase())) {
      return "Password is too common. Please choose a stronger one.";
    }

    if (email != null && email.isNotEmpty) {
      final username = email.split('@').first;
      // Avoid flagging short usernames that might appear in many words.
      if (username.length > 3 &&
          password.toLowerCase().contains(username.toLowerCase())) {
        return "Password cannot be too similar to your email.";
      }
    }

    return null; // Return null if validation passes
  }

  void onPasswordChanged(String password) {
    passwordError.value = validatePassword(password, email: emailCtr.text);
  }

  void onConfirmPasswordChanged(String value) {
    if (passwordCtr.text != value) {
      confirmPasswordError.value = "Passwords do not match";
    } else {
      confirmPasswordError.value = null;
    }
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
    nameError.value = validateName(nameCtr.text);
    onConfirmPasswordChanged(confirmPasswordCtr.text);

    // Only proceed with registration if there are no errors
    if (emailError.value == null &&
        passwordError.value == null &&
        nameError.value == null &&
        confirmPasswordError.value == null) {
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
              isLoading.value = false;
              // Navigate to the home page on successful registration
              Get.offAllNamed(Routes.HOME);
              CustomToast.showSuccessToast(
                response.message ?? "Account created successfully",
              );
            },
            onError: (e) {
              isLoading.value = false;
              if (e is ApiException) {
                CustomToast.showErrorToast(e.description);
                return;
              }
              CustomToast.showErrorToast('An unexpected error occurred');
            },
          );
    }
  }

  @override
  void onClose() {
    emailCtr.dispose();
    passwordCtr.dispose();
    nameCtr.dispose();
    confirmPasswordCtr.dispose();
    super.onClose();
  }

  void onGoogleLogin() async {
    try {
      final String? token = await GoogleSignInApi.login();

      if (token != null) {
        CustomToast.showSuccessToast("Google Login Successful");
        Get.offAndToNamed(Routes.HOME);
      } else {
        CustomToast.showErrorToast("Google Login Failed");
      }
    } catch (e) {
      CustomToast.showErrorToast("Google Login Failed");
    }
  }
}
