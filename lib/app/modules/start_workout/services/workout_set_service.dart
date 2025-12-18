import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/modules/start_workout/controllers/start_workout_controller.dart';

import '../models/workout_set_data.dart';

class WorkoutSetService extends GetxService {
  final RxList<WorkoutSetData> workoutSets = [
    WorkoutSetData(
      setType: '1',
      previous: '100 kg x 5',
      kgController: TextEditingController(text: '100'),
      repsController: TextEditingController(text: '5'),
      isComplete: false,
    ),
    WorkoutSetData(
      setType: '2',
      previous: '100 kg x 8',
      kgController: TextEditingController(text: '100'),
      repsController: TextEditingController(text: '8'),
      isComplete: false,
    ),
  ].obs;
  StartWorkoutController? _controller;

  void attach(StartWorkoutController controller) {
    _controller = controller;
  }

  void detach() {
    _controller = null;
    for (var set in workoutSets) {
      set.kgController.dispose();
      set.repsController.dispose();
    }
  }

  void updateSetType( int index, String type,) {
    workoutSets[index].copyWith(setType: type);
    workoutSets.refresh();
  }
}
