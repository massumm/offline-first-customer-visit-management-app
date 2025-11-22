import 'package:get/get.dart';
import 'package:icon/app/modules/icon_chat/controllers/icon_chat_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<IconChatController>(
      () => IconChatController(),
      fenix: true,
    );
  }
}
