import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
// import 'package:icon/app/data/local/preference/preference_service.dart'; // TODO: Uncomment when using actual API
import 'package:icon/app/modules/register/repository/registration_repository.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../core/theme/services/theme_service.dart';
import '../../../core/widgets/google_sign_in_api.dart';

class RegisterController extends BaseController {
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  final nameCtr = TextEditingController();
  var obscurePassword = true.obs;
  var agreeToService = false.obs;

  // OTP Controllers for email verification
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();
  final otp5Controller = TextEditingController();
  final otp6Controller = TextEditingController();

  final otp1FocusNode = FocusNode();
  final otp2FocusNode = FocusNode();
  final otp3FocusNode = FocusNode();
  final otp4FocusNode = FocusNode();
  final otp5FocusNode = FocusNode();
  final otp6FocusNode = FocusNode();

  // Resend timer
  var resendTimer = 60.obs;
  var canResend = false.obs;
  Timer? _timer;

  // Store verification key
  var verificationKey = '';

  // TextInput validation error
  var passwordError = RxnString();
  var emailError = RxnString();
  var nameError = RxnString();
  var isLoading = false.obs;
  var isVerifying = false.obs;
  var emailOtpError = RxnString();

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

    // For a production app, consider using a service or a more extensive,
    // securely stored list of common passwords.
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

  // Add this method to be called on every keystroke in the password field.
  void onPasswordChanged(String password) {
    // Pass the email for the similarity check.
    passwordError.value = validatePassword(password, email: emailCtr.text);
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

    // Only proceed with registration if there are no errors
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
              isLoading.value = false;
              // Navigate to two-factor authentication setup page
              Get.toNamed(Routes.Two_Factor_Verification);
              CustomToast.showSuccessToast(
                response.message ?? "Account created successfully",
              );
            },
            onError: (e) {
              isLoading.value = false;
              if (e is ApiException) {
                CustomToast.showErrorToast(e.message);
                return;
              }
              CustomToast.showErrorToast('An unexpected error occurred');
            },
          );
    }
  }

  void sendVerificationEmail() {
    if (isVerifying.isTrue) return;

    isVerifying(true);

    // TODO: Call API to send verification email
    // For now, simulate sending and navigate to OTP page
    Future.delayed(const Duration(seconds: 1), () {
      isVerifying.value = false;
      // Navigate to OTP page
      Get.toNamed(Routes.EMAIL_VERIFICATION_OTP);
      CustomToast.showSuccessToast('Verification code sent to your email');
      _startResendTimer();
    });
  }

  void verifyEmailOtp() {
    if (isLoading.isTrue) return;

    final otp = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;

    if (otp.length != 6) {
      emailOtpError.value = 'Please enter complete OTP';
      CustomToast.showErrorToast('Please enter complete OTP');
      return;
    }

    // TODO: Remove this temporary bypass and use actual API verification
    // Temporarily accept any 6-digit OTP
    isLoading(true);
    
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      _clearOtpFields();
      emailOtpError.value = null;
      _timer?.cancel();
      Get.offAllNamed(Routes.TWO_FACTOR_SUCCESS);
      CustomToast.showSuccessToast('Email verified successfully!');
    });

    /* 
    // Original API implementation - uncomment when ready to use
    final otpRequestBody = {
      "email": emailCtr.text,
      "code": otp,
    };

    // Step 1: Verify OTP
    _registrationRepository.verifyOtp(otpRequestBody).then(
      (otpResponse) async {
        // Step 2: Save the key from response to shared preferences
        final String verificationKey = otpResponse['key'] ?? '';
        if (verificationKey.isEmpty) {
          isLoading.value = false;
          CustomToast.showErrorToast('Invalid verification key received');
          throw Exception('Invalid verification key');
        }

        // Save key to shared preferences
        await StorageService.to.setString('verification_key', verificationKey);

        // Step 3: Call verify email API with the saved key
        final emailVerifyRequestBody = {
          "key": verificationKey,
        };

        return await _registrationRepository.verifyEmail(emailVerifyRequestBody);
      },
    ).then(
      (emailResponse) async {
        isLoading.value = false;
        _clearOtpFields();
        _timer?.cancel();
        // Clear the verification key from storage after successful verification
        await StorageService.to.remove('verification_key');
        Get.offAllNamed(Routes.TWO_FACTOR_SUCCESS);
        CustomToast.showSuccessToast('Email verified successfully!');
      },
    ).catchError((e) {
      isLoading.value = false;
      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
        return;
      }
      CustomToast.showErrorToast('An unexpected error occurred');
    });
    */
  }

  void resendEmailOtp() {
    if (!canResend.value) return;

    // TODO: Call API to resend OTP
    CustomToast.showSuccessToast('OTP sent to your email');
    _startResendTimer();
  }

  void _startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void _clearOtpFields() {
    otp1Controller.clear();
    otp2Controller.clear();
    otp3Controller.clear();
    otp4Controller.clear();
    otp5Controller.clear();
    otp6Controller.clear();
    emailOtpError.value = null;
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailCtr.dispose();
    passwordCtr.dispose();
    nameCtr.dispose();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    otp6Controller.dispose();
    otp1FocusNode.dispose();
    otp2FocusNode.dispose();
    otp3FocusNode.dispose();
    otp4FocusNode.dispose();
    otp5FocusNode.dispose();
    otp6FocusNode.dispose();
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
