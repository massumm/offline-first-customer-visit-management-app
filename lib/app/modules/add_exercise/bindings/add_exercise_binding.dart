import 'package:get/get.dart';

import '../controllers/add_exercise_controller.dart';
import '../repository/add_exercise_repository.dart';
import '../repository/add_exercise_repository_impl.dart';

class AddExerciseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddExerciseController>(() => AddExerciseController());

    Get.lazyPut<AddExerciseRepository>(
      () => AddExerciseRepositoryImpl(),
      tag: (AddExerciseRepository).toString(),
    );
  }
}
