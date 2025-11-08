import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/forgot_password/repository/forgot_password_repository.dart';
import 'package:icon/app/modules/forgot_password/views/choose_password_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/forgot_password_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/otp_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/password_change_success_view.dart';

class ForgotPasswordController extends BaseController {
  final _forgotPasswordRepository = Get.find<ForgotPasswordRepository>();
  final pageController = PageController();

  List<Widget> get pages => [
    ForgotPasswordPageView(),
    OtpPageView(),
    ChoosePasswordPageView(),
    PasswordChangeSuccessView(),
  ];

  final currentPageIndex = 0.obs;

  final emailController = TextEditingController();
  final emailError = RxnString();

  // OTP Controllers
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

  final otpError = RxnString();
  final resendTimer = 30.obs;
  final canResend = false.obs;
  bool _isTimerRunning = false;

  // Password Controllers
  final resetTokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetTokenError = RxnString();
  final newPasswordError = RxnString();
  final confirmPasswordError = RxnString();
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Loading state for send OTP
  final isSendingOtp = false.obs;

  Widget get forgotPasswordDefaultHeight => 80.height;

  void onPageChange(int index) {
    currentPageIndex.value = index;
  }

  void gotToNextPage() {
    // Validate email on first page
    if (currentPageIndex.value == 0) {
      if (emailController.text.isEmpty) {
        emailError.value = "Email is required";
        return;
      }

      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(emailController.text)) {
        emailError.value = "Please enter a valid email";
        return;
      }

      // Clear error if validation passes
      emailError.value = null;

      // Call password reset request API
      sendPasswordResetRequest();
      return;
    }

    if (currentPageIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentPageIndex.value++;

      // Start timer when reaching OTP page
      if (currentPageIndex.value == 1 && !_isTimerRunning) {
        startResendTimer();
      }
    }
  }

  void sendPasswordResetRequest() {
    if (isSendingOtp.isTrue) return;

    isSendingOtp(true);

    final requestBody = {"email": emailController.text};

    // Step 1: Request password reset
    _forgotPasswordRepository
        .requestPasswordReset(requestBody)
        .then((passwordResetResponse) {
          // Step 2: Request OTP after password reset request succeeds
          return _forgotPasswordRepository.requestOtp(requestBody);
        })
        .then((otpResponse) {
          isSendingOtp.value = false;
          // Navigate to OTP page
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          currentPageIndex.value++;

          // Start timer when reaching OTP page
          if (!_isTimerRunning) {
            startResendTimer();
          }

          CustomToast.showSuccessToast(otpResponse['detail'] ?? 'OTP sent.');
        })
        .catchError((e) {
          isSendingOtp.value = false;
          if (e is ApiException) {
            CustomToast.showErrorToast(e.description);
            return;
          }
          CustomToast.showErrorToast('An unexpected error occurred');
        });
  }

  void gotToPreviousPage() {
    if (currentPageIndex.value > 0) {
      if (currentPageIndex.value == 1) {
        clearOtpPageValues();
      }

      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentPageIndex.value--;
    }
  }



  void verifyOtp() {
    final otp =
        otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;

    if (otp.length != 6) {
      otpError.value = "Please enter complete OTP";
      return;
    }

    final requestBody = {"email": emailController.text, "code": otp};

    _forgotPasswordRepository
        .verifyOtp(requestBody)
        .then(
          (response) {
            // Store tokens if provided
            if (response['access'] != null) {
              // TODO: Store access token
            }
            if (response['refresh'] != null) {
              // TODO: Store refresh token
            }

            // Navigate to next page (choose password)
            gotToNextPage();

            CustomToast.showSuccessToast(
              response['detail'] ?? 'OTP verified successfully.',
            );
          },
          onError: (e) {
            if (e is ApiException) {
              otpError.value = e.description;
              CustomToast.showErrorToast(e.description);
              return;
            }
            CustomToast.showErrorToast('An unexpected error occurred');
          },
        );
  }

  void resendOtp() {
    if (!canResend.value) return;

    // TODO: Implement resend OTP logic
    canResend.value = false;
    resendTimer.value = 30;
    startResendTimer();
  }

  void startResendTimer() {
    _isTimerRunning = true;
    resendTimer.value = 30;
    canResend.value = false;

    _runTimer();
  }

  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isTimerRunning && resendTimer.value > 0) {
        resendTimer.value--;
        _runTimer();
      } else if (resendTimer.value == 0) {
        canResend.value = true;
        _isTimerRunning = false;
      }
    });
  }

  void resetPassword() {
    // Clear previous errors
    resetTokenError.value = null;
    newPasswordError.value = null;
    confirmPasswordError.value = null;

    // Validate reset token
    if (resetTokenController.text.isEmpty) {
      resetTokenError.value = "Reset token is required";
      return;
    }

    // Validate new password
    if (newPasswordController.text.isEmpty) {
      newPasswordError.value = "Password is required";
      return;
    }

    if (newPasswordController.text.length < 8) {
      newPasswordError.value = "Must be at least 8 characters";
      return;
    }

    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = "Please confirm your password";
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = "Both passwords must match";
      return;
    }

    // Call password reset confirm API
    final requestBody = {
      "token": resetTokenController.text,
      "new_password": newPasswordController.text,
    };

    _forgotPasswordRepository
        .resetPasswordConfirm(requestBody)
        .then(
          (response) {
            // Navigate to success page
            gotToNextPage();

            CustomToast.showSuccessToast(
              response['detail'] ?? 'Password reset successful.',
            );
          },
          onError: (e) {
            if (e is ApiException) {
              // Check if error is related to token
              if (e.description.toLowerCase().contains('token') ||
                  e.description.toLowerCase().contains('uuid')) {
                resetTokenError.value = e.description;
              } else {
                newPasswordError.value = e.description;
              }
              CustomToast.showErrorToast(e.description);
              return;
            }
            CustomToast.showErrorToast('An unexpected error occurred');
          },
        );
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  @override
  void onClose() {
    _isTimerRunning = false;
    pageController.dispose();
    emailController.dispose();
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
    resetTokenController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void clearOtpPageValues() {
    otp1Controller.clear();
    otp2Controller.clear();
    otp3Controller.clear();
    otp4Controller.clear();
    otp5Controller.clear();
    otp6Controller.clear();
    otpError.value = null;
    _isTimerRunning = false;
    resendTimer.value = 30;
    canResend.value = false;
  }
}
