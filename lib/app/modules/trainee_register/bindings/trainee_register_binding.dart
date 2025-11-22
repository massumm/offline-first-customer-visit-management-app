import 'package:get/get.dart';
import 'package:icon/app/modules/register/repository/registration_repository_impl.dart';

import '../../register/repository/registration_repository.dart';
import '../controllers/trainee_register_controller.dart';

class TraineeRegisterBinding extends Bindings {
  @override
  void dependencies() {
    // ----------- Repository -------------------
    Get.lazyPut<RegistrationRepository>(
      () => RegistrationRepositoryImpl(),
      tag: (RegistrationRepository).toString()
    );
    // ----------- Controller -------------------
    Get.lazyPut<TraineeRegisterController>(
      () => TraineeRegisterController(),
    );

  }
}
