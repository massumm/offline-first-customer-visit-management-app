import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends BaseView<ForgotPasswordController> {
  ForgotPasswordView({super.key});
  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ForgotPasswordView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ForgotPasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
