import 'package:get/get.dart';
import '../controllers/profile_create_animation_controller.dart';

class ProfileCreateAnimationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileCreateAnimationController>(
      () => ProfileCreateAnimationController(),
    );
  }
}
