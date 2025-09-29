import 'package:get/get.dart';
import 'package:icon/app/modules/register/repository/registration_repository.dart';
import 'package:icon/app/modules/register/repository/registration_repository_impl.dart';

import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationRepository>(
          () => RegistrationRepositoryImpl(),
      tag: (RegistrationRepository).toString(),
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
  }
}
