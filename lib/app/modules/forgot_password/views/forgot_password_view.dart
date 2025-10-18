import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends BaseView<ForgotPasswordController> {
  ForgotPasswordView({super.key});
  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChange,
        children: controller.pages,
      ),
    );
  }
}
