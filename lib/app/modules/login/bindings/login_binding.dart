import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/repository/login_repository.dart';
import '../controllers/repository/login_repository_impl.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // ............. Repository ............
    Get.lazyPut<LoginRepository>(
          () => LoginRepositoryImpl(),
      tag: (LoginRepository).toString(),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
