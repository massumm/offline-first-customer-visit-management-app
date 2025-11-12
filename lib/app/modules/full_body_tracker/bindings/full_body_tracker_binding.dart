import 'package:get/get.dart';

import '../controllers/full_body_tracker_controller.dart';

class FullBodyTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FullBodyTrackerController>(
      () => FullBodyTrackerController(),
    );
  }
}
