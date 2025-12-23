import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/recovery_tracker/models/activity_types_response_model.dart';

import '../../../routes/app_pages.dart';
import '../models/activity_type_model.dart';
import '../repository/recovery_tracker_repository.dart';

enum RecoveryType { repair, sleep, wellbeing }

class RecoveryTrackerController extends BaseController {
  final RecoveryTrackerRepository _recoveryTrackerRepository = Get.find(
    tag: (RecoveryTrackerRepository).toString(),
  );

  /// ---------------- UI STATE ----------------
  final RxBool isOpened = false.obs;
  final RxDouble height = 0.0.obs;
  final RxDouble cardContainerHeight = 0.0.obs;
  final double openedHeight = Get.height;
  final RxBool isRepairBtnSelected = false.obs;
  final RxBool isSleepBtnSelected = false.obs;
  final RxBool isWellbeingBtnSelected = false.obs;
  final RxList<ActivityTypeModel> activityTypes = <ActivityTypeModel>[].obs;
  final Rxn<String> selectedActivityType = Rxn<String>();

  @override
  void onInit() {
    super.onInit();

    ever(isOpened, (bool opened) {
      height.value = opened ? openedHeight : 0.0;
      cardContainerHeight.value = opened ? 180 : 0.0;
      if (!opened) {
        isRepairBtnSelected.value = false;
        isSleepBtnSelected.value = false;
        isWellbeingBtnSelected.value = false;
      }
    });

    _recoveryTrackerRepository.getActivityTypes().then((
      ActivityTypesResponseModel data,
    ) {
      activityTypes.addAll(data.results!);
    });
  }

  void recoveryTypeSelected(RecoveryType recoveryType) {
    switch (recoveryType) {
      case RecoveryType.repair:
        isRepairBtnSelected.value = true;
        isSleepBtnSelected.value = false;
        isWellbeingBtnSelected.value = false;
        break;
      case RecoveryType.sleep:
        isSleepBtnSelected.value = true;
        isRepairBtnSelected.value = false;
        isWellbeingBtnSelected.value = false;
        break;
      case RecoveryType.wellbeing:
        isWellbeingBtnSelected.value = true;
        isRepairBtnSelected.value = false;
        isSleepBtnSelected.value = false;
        break;
    }

    cardContainerHeight.value = 290;
  }

  void gotoQuickAddPage() {
    Get.toNamed(Routes.RECOVERY_TRACKER_ENTRY);
  }
}
