import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/modules/home/controllers/home_controller.dart';

import '../controllers/trainer_onboarding_controller.dart';

class TrainerOnboardingView extends GetView<TrainerOnboardingController> {
  const TrainerOnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrainerOnboardingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TrainerOnboardingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}