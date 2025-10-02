import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/activity_tracker_controller.dart';

class ActivityTrackerView extends GetView<ActivityTrackerController> {
  const ActivityTrackerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActivityTrackerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActivityTrackerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
