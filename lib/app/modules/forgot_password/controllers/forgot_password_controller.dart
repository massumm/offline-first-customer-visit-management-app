import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/forgot_password/views/choose_password_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/forgot_password_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/otp_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/password_change_success_view.dart';

class ForgotPasswordController extends BaseController {
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
  
  final otpError = RxnString();
  final resendTimer = 30.obs;
  final canResend = false.obs;
  bool _isTimerRunning = false;

  // Password Controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final newPasswordError = RxnString();
  final confirmPasswordError = RxnString();
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

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

  void gotToPreviousPage() {
    if (currentPageIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentPageIndex.value--;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void verifyOtp() {
    final otp = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;

    if (otp.length != 6) {
      otpError.value = "Please enter complete OTP";
      return;
    }

    // TODO: Implement OTP verification logic
    gotToNextPage();
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
    newPasswordError.value = null;
    confirmPasswordError.value = null;

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

    // TODO: Implement password reset API call
    gotToNextPage();
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
