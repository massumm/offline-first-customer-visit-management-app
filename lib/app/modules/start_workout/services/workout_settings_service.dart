import 'package:get/get.dart';
import 'package:icon/app/modules/start_workout/controllers/start_workout_controller.dart';

// workout setting business logic.
class WorkoutSettingsService extends GetxService {
  StartWorkoutController? _c;

  void attach(StartWorkoutController controller) {
    _c = controller;
  }

  void detach() {
    _c = null;
  }
}
