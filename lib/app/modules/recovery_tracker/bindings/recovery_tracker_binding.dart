import 'package:get/get.dart';

import '../controllers/recovery_tracker_controller.dart';

class RecoveryTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoveryTrackerController>(
      () => RecoveryTrackerController(),
    );
  }
}
