import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icon/app/modules/workout/controllers/workout_controller.dart';

class SaveWorkoutService extends GetxService {
  final RxString notes = ''.obs;
  final RxString error = RxString('');
  final RxBool loading = false.obs;
  final RxString photoPath = ''.obs;

  WorkoutController? _controller;

  void attach(WorkoutController workoutController) {
    _controller = workoutController;
    notes.value = '';
    photoPath.value = '';
    error.value = '';
    loading.value = false;
  }


  void detach() {
    _controller = null;
    notes.value = '';
    photoPath.value = '';
    error.value = '';
    loading.value = false;
  }


  Future<void> pickPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        photoPath.value = pickedFile.path;
      }
    } catch (e) {
      error.value = 'Failed to pick the photo';
    }
  }

  Future<void> saveWorkout() async {
    if (_controller == null) {
      error.value = 'Controller not attached.';
      return;
    }
    loading.value = true;
    error.value = '';
    try {
      await Future.delayed(Duration(seconds: 3));
      Get.back();
    } catch (e) {
      error.value = 'Failed to save workout.';
    }
    loading.value = false;
  }
}
