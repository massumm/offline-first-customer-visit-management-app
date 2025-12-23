import 'package:get/get.dart';
import 'package:icon/app/modules/activity_tracker/models/workout_response_model.dart';
import 'package:vibration/vibration.dart';

import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../models/workout_set_data.dart';
import '../widgets/bottom_sheet/show_set_type_bottom_sheet.dart';

class WorkoutService extends GetxService {
  final RxList<WorkoutSetData> workoutSets = [
    WorkoutSetData(
      setType: '1',
      previous: '100 kg x 5',
      kg: '100',
      reps: '5',
      isComplete: false,
    ),
    WorkoutSetData(
      setType: '2',
      previous: '100 kg x 8',
      kg: '100',
      reps: '8',
      isComplete: false,
    ),
    WorkoutSetData(
      setType: '3',
      previous: '100 kg x 8',
      kg: '100',
      reps: '8',
      isComplete: false,
    ),
    WorkoutSetData(
      setType: '4',
      previous: '100 kg x 8',
      kg: '100',
      reps: '8',
      isComplete: false,
    ),
    WorkoutSetData(
      setType: '5',
      previous: '100 kg x 8',
      kg: '100',
      reps: '8',
      isComplete: false,
    ),
  ].obs;

  final RxList<ExerciseElement> exerciseData = <ExerciseElement>[].obs;

  // Main Controller.
  WorkoutController? _controller;

  void attach(WorkoutController controller) {
    _controller = controller;
  }

  void detach() {
    _controller = null;
  }

  void addSet() {
    if (workoutSets.isEmpty) {
      workoutSets.add(
        WorkoutSetData(
          setType: '1',
          previous: '',
          kg: '',
          reps: '',
          isComplete: false,
        ),
      );
      return;
    }

    final lastSet = workoutSets.last;
    workoutSets.add(
      WorkoutSetData(
        setType: '1',
        previous: '',
        kg: lastSet.kg,
        reps: lastSet.reps,
        isComplete: false,
      ),
    );

    int counter = 1;
    for (int i = 0; i < workoutSets.length; i++) {
      final currentSet = workoutSets[i];
      final isNormal = int.tryParse(currentSet.setType) != null;

      if (currentSet.setType == 'F') {
        continue;
      } else if (isNormal) {
        workoutSets[i] = currentSet.copyWith(setType: counter.toString());
        counter++;
      } else {
        counter++;
      }
    }

    workoutSets.refresh();
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
        counter++;
      }
    }

    workoutSets.refresh();
  }

  void onSetComplete(int index) {
    workoutSets[index] = workoutSets[index].copyWith(isComplete: true);
    workoutSets.refresh();
  }

  void toggleCompletion(int index, bool isCompleted) async {
    if (isCompleted) {
      if (await (Vibration.hasVibrator())) {
        Vibration.vibrate(duration: 140);
      }
    }
    workoutSets[index] = workoutSets[index].copyWith(isComplete: isCompleted);
    workoutSets.refresh();
  }

  void removeSet(int index) {
    workoutSets.removeAt(index);

    // Reorder the set type numbers to maintain sequence.
    int counter = 1;
    for (int i = 0; i < workoutSets.length; i++) {
      final currentSet = workoutSets[i];
      final isNormal = int.tryParse(currentSet.setType) != null;

      if (currentSet.setType == 'F') {
        // Failure sets are not part of the main numbering, so we skip.
        continue;
      } else if (isNormal) {
        workoutSets[i] = currentSet.copyWith(setType: counter.toString());
        counter++;
      } else {
        counter++;
      }
    }

    workoutSets.refresh();
  }

  void updateKg(int index, String value) {
    workoutSets[index] = workoutSets[index].copyWith(kg: value);
    workoutSets.refresh();
  }

  void updateReps(int index, String value) {
    workoutSets[index] = workoutSets[index].copyWith(reps: value);
    workoutSets.refresh();
  }
}
