import 'package:get/get.dart';

import '../controllers/trainee_register_controller.dart';

class TraineeRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraineeRegisterController>(
      () => TraineeRegisterController(),
    );
  }
}
