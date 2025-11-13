import 'package:get/get.dart';

import '../controllers/icon_profile_controller.dart';

class IconProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IconProfileController>(
      () => IconProfileController(),
    );
  }
}
