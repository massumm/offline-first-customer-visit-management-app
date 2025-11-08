import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

import '../../../base/widgets/custom_toast.dart';
import '../../../routes/app_pages.dart';

class OtpValidationController extends BaseController {
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

  var emailOtpError = RxnString();

  var resendTimer = 60.obs;
  var canResend = false.obs;
  Timer? _timer;

  var isLoading = false.obs;
  var isVerifying = false.obs;


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
  }

  @override
  void onClose() {
    _timer?.cancel();
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
}
