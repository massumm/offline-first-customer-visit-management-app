import 'package:get/get.dart';

import '../controllers/recovery_tracker_controller.dart';
import '../repository/recovery_tracker_repository.dart';
import '../repository/recovery_tracker_repository_impl.dart';

class RecoveryTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoveryTrackerController>(() => RecoveryTrackerController());

    Get.lazyPut<RecoveryTrackerRepository>(
      () => RecoveryTrackerRepositoryImpl(),
      tag: (RecoveryTrackerRepository).toString(),
    );
  }
}
