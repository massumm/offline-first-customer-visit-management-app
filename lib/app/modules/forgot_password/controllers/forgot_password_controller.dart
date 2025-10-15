import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/forgot_password/views/choose_password_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/forgot_password_page_view.dart';
import 'package:icon/app/modules/forgot_password/views/otp_page_view.dart';

class ForgotPasswordController extends BaseController {
  final pageController = PageController();

  final pages = [
    ForgotPasswordPageView(),
    OtpPageView(),
    ChoosePasswordPageView(),
  ];

  final currentPageIndex = 0.obs;

  void onPageChange(int index) {
    currentPageIndex.value = index;
  }

  void gotToNextPage() {
    if(currentPageIndex.value < pages.length - 1){
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentPageIndex.value++;
    }
  }

  void gotToPreviousPage() {
    if(currentPageIndex.value > 0){
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

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

}
