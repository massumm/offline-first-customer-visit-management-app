import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/modules/start_workout/controllers/start_workout_controller.dart';
import 'package:icon/app/modules/start_workout/views/widgets/bottom_sheet/show_set_type_bottom_sheet.dart';

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

  void updateSetType(int index, SetType type) {
    if (type == SetType.remove) {
      workoutSets.removeAt(index);
    } else if (type == SetType.normal) {
      // If the set is already a numbered set,
      if (int.tryParse(workoutSets[index].setType) != null) {
        return;
      }
      // Mark the set as a normal set.
      workoutSets[index] = workoutSets[index].copyWith(setType: '1');
    } else {
      // Handle other set types
      workoutSets[index] = workoutSets[index].copyWith(
        setType: type.shortLabel,
      );
    }

    // Handle the number order,
    int normalSetCounter = 1;
    for (int i = 0; i < workoutSets.length; i++) {
      if (int.tryParse(workoutSets[i].setType) != null) {
        workoutSets[i] = workoutSets[i].copyWith(
          setType: normalSetCounter.toString(),
        );
        normalSetCounter++;
      }
    }
    workoutSets.refresh();
  }
}
