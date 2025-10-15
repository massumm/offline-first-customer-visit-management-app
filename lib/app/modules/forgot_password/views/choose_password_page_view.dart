import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/modules/forgot_password/controllers/forgot_password_controller.dart';

class ChoosePasswordPageView extends BaseView<ForgotPasswordController> {
  ChoosePasswordPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChoosePasswordPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChoosePasswordPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}