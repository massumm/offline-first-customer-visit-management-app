import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/start_workout_controller.dart';

class StartWorkoutView extends GetView<StartWorkoutController> {
  const StartWorkoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StartWorkoutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StartWorkoutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
