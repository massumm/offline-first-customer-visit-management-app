import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';
import '../repository/forgot_password_repository.dart';
import '../repository/forgot_password_repository_impl.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordRepository>(
      () => ForgotPasswordRepositoryImpl(),
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
