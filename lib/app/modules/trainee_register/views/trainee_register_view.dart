import 'package:flutter/material.dart';

import 'package:icon/app/base/base_view.dart';

import '../controllers/trainee_register_controller.dart';

class TraineeRegisterView extends BaseView<TraineeRegisterController> {
  const TraineeRegisterView({super.key});
  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TraineeRegisterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TraineeRegisterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
