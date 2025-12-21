import 'package:get/get.dart';

import '../controllers/activity_tracker_controller.dart';
import '../repository/activity_tracker_repository.dart';
import '../repository/activity_tracker_repository_impl.dart';

class ActivityTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityTrackerController>(() => ActivityTrackerController());

    Get.lazyPut<ActivityTrackerRepository>(
      () => ActivityTrackerRepositoryImpl(),
      tag: (ActivityTrackerRepository).toString(),
    );
  }
}
