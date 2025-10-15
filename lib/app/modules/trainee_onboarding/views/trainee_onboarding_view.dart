import 'package:flutter/material.dart';

import 'package:icon/app/base/base_view.dart';

import '../controllers/trainee_onboarding_controller.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  TraineeOnboardingView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TraineeOnboardingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TraineeOnboardingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
