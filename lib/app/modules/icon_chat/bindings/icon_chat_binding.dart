import 'package:get/get.dart';

import '../controllers/icon_chat_controller.dart';

class IconChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IconChatController>(
      () => IconChatController(),
    );
  }
}
