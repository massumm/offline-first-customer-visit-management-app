import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/trainee_onboarding_controller.dart';

class TraineeOnboardingView extends GetView<TraineeOnboardingController> {
  const TraineeOnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
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
