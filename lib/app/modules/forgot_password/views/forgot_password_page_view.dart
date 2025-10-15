import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/modules/forgot_password/controllers/forgot_password_controller.dart';

class ForgotPasswordPageView extends BaseView<ForgotPasswordController> {
  ForgotPasswordPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ForgotPasswordPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ForgotPasswordPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}