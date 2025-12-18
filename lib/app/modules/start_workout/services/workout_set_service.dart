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
    WorkoutSetData(
      setType: '3',
      previous: '100 kg x 8',
      kgController: TextEditingController(text: '100'),
      repsController: TextEditingController(text: '8'),
      isComplete: false,
    ),
    WorkoutSetData(
      setType: '4',
      previous: '100 kg x 8',
      kgController: TextEditingController(text: '100'),
      repsController: TextEditingController(text: '8'),
      isComplete: false,
    ),
    WorkoutSetData(
      setType: '5',
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
      // Mark as a number so it gets picked up by the numbering logic
      workoutSets[index] = workoutSets[index].copyWith(setType: '1');
    } else {
      // Apply special types
      workoutSets[index] = workoutSets[index].copyWith(
        setType: type.shortLabel,
      );
    }

    int counter = 1;

    for (int i = 0; i < workoutSets.length; i++) {
      final currentSet = workoutSets[i];
      final isFailure = currentSet.setType == SetType.failure.shortLabel;
      final isNormal = int.tryParse(currentSet.setType) != null;

      if (isFailure) {
        continue;
      } else if (isNormal) {
        workoutSets[i] = currentSet.copyWith(setType: counter.toString());
        counter++;
      } else {
        // Other types
        // They keep their label but consume a number in the sequence.
        counter++;
      }
    }
    
    workoutSets.refresh();
  }
}
