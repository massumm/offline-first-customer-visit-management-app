import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

class ActivityTrackerController extends BaseController {
  final RxBool isOpened = false.obs;
  final RxDouble height = 0.0.obs;
  final double openedHeight = Get.height;
  final RxDouble cardContainerHeight = 0.0.obs;
  // ---------------  States ---------------
  final RxBool isWorkoutBtnSelected = false.obs;
  final RxBool isCardioBtnSelected = false.obs;
  final RxBool isRepairBtnSelected = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(isOpened, (bool opened) {
      height.value = opened ? openedHeight : 0.0;
      cardContainerHeight.value = opened ? 290 : 0.0;
    });
  }

  // Bottom Buttons tripper methods
  void onWorkoutTap() {
    isWorkoutBtnSelected.toggle();
    isCardioBtnSelected(false);
    isRepairBtnSelected(false);
  }

  void onCardioTap() {
    isWorkoutBtnSelected(false);
    isCardioBtnSelected.toggle();
    isRepairBtnSelected(false);
  }

  void onRepairTap() {
    isWorkoutBtnSelected(false);
    isCardioBtnSelected(false);
    isRepairBtnSelected.toggle();
  }
}
