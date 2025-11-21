import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/workout_history_controller.dart';

class RecordsView extends StatelessWidget {
  const RecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutHistoryController>(
      builder: (controller) => records(controller),
    );
  }

  Widget records(WorkoutHistoryController controller) {
    return const Center(
      child: Text('Records Content'),
    );
  }
}
