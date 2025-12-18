import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

class NutritionTrackerController extends BaseController {
  final RxBool isOpened = false.obs;
  final RxDouble height = 0.0.obs;
  final double openedHeight = Get.height;
  final RxDouble cardContainerHeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(isOpened, (bool opened) {
      height.value = opened ? openedHeight : 0.0;
      cardContainerHeight.value = opened ? 290 : 0.0;
    });
  }
}
