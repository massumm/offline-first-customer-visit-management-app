import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

class ActivityTrackerController extends BaseController {
  // ---------------  States ---------------
  final RxBool isWorkoutBtnSelected = false.obs;
  final RxBool isCardioBtnSelected = false.obs;
  final RxBool isRepairBtnSelected = false.obs;

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
