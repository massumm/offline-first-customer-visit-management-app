import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WorkoutViewView extends GetView {
  const WorkoutViewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkoutViewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WorkoutViewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
