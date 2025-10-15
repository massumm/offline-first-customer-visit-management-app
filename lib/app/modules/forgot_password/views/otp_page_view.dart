import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/modules/forgot_password/controllers/forgot_password_controller.dart';

class OtpPageView extends BaseView<ForgotPasswordController> {
  OtpPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OtpPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OtpPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}