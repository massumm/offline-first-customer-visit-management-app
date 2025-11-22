import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';

import '../../../base/widgets/custom_toast.dart';
import '../../../routes/app_pages.dart';
import '../repository/otp_verifications_repository.dart';

class OtpValidationController extends BaseController {
  // -------------- Repository -------------
  final OtpVerificationsRepository _repository =
      Get.find<OtpVerificationsRepository>(
        tag: (OtpVerificationsRepository).toString(),
      );

  // -------------- Local Data --------------
  final String email = Get.arguments['email'];
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

  static const _initialTimerSeconds = 60;

  // Controls the enabled/disabled state of the resend button
  final canResend = false.obs;

  // Holds the current countdown value
  final resendTimer = _initialTimerSeconds.obs;
  Timer? _timer;

  var isLoading = false.obs;
  var isVerifying = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Start the countdown timer as soon as the controller is initialized
    startResendTimer();
  }

  void startResendTimer() {
    // Reset the state
    canResend.value = false;
    resendTimer.value = _initialTimerSeconds;

    // Cancel any existing timer
    _timer?.cancel();

    // Start a new periodic timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        // Decrement the timer
        resendTimer.value--;
      } else {
        // When the timer reaches 0, enable the resend button and stop the timer
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void verifyEmailOtp() async {
    if (isLoading.isTrue) return;

    final otp =
        otp1Controller.text +
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

    // Temporarily accept any 6-digit OTP
    isLoading(true);

    await _repository
        .varifyOtp({'code': otp, 'email': email})
        .then(
          (response) {
            CustomToast.showSuccessToast('Email verified successfully!');
            Get.offAllNamed(Routes.ICON_CHAT);
          },
          onError: (e) {
            if (e is ApiException) {
              emailOtpError.value = e.toString();
              CustomToast.showErrorToast(e.description);
              return;
            }
            CustomToast.showErrorToast(e.toString());
          },
        )
        .whenComplete(() {
          isLoading.value = false;
          _clearOtpFields();
          emailOtpError.value = null;
        });
  }

  void resendEmailOtp() {
    if (!canResend.value) return;

    isLoading(true);
    _repository
        .otpRequest({'email': email})
        .then(
          (response) {
            CustomToast.showSuccessToast('OTP sent to your email');
            startResendTimer();
            isLoading.value = false;
          },
          onError: (e) {
            isLoading.value = false;
            if (e is ApiException) {
              emailOtpError.value = e.toString();
              CustomToast.showErrorToast(e.description);
              return;
            }
            CustomToast.showErrorToast(e.toString());
          },
        );
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
