import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../routes/app_pages.dart';
import '../models/activity_logs_response_model.dart';
import '../repository/activity_tracker_repository.dart';

enum ActionType { workout, cardio, repair }

class ActivityTrackerController extends BaseController {
  final RxBool isOpened = false.obs;
  final RxBool isLoading = true.obs;
  final RxDouble height = 0.0.obs;
  final double openedHeight = Get.height;
  final RxDouble cardContainerHeight = 0.0.obs;
  final RxBool isWorkoutBtnSelected = false.obs;
  final RxBool isCardioBtnSelected = false.obs;
  final RxBool isRepairBtnSelected = false.obs;

  final RxList<Workout> activityLogs = <Workout>[].obs;

  final ActivityTrackerRepository _activityTrackerRepository = Get.find(
    tag: (ActivityTrackerRepository).toString(),
  );

  @override
  void onInit() {
    super.onInit();
    ever(isOpened, (bool opened) {
      height.value = opened ? openedHeight : 0.0;
      cardContainerHeight.value = opened ? 180 : 0.0;
      if (!opened) {
        isWorkoutBtnSelected.value = false;
        isCardioBtnSelected.value = false;
        isRepairBtnSelected.value = false;
      }
    });

    _activityTrackerRepository.activityLogs().then((
      ActivityLogsResponseModel response,
    ) {
      activityLogs.value = response.workouts!;
      isLoading.value = false;
    });
  }

  void activityBtnSelected(ActionType actionType) {
    switch (actionType) {
      case ActionType.workout:
        isWorkoutBtnSelected.value = true;
        isCardioBtnSelected.value = false;
        isRepairBtnSelected.value = false;
        break;
      case ActionType.cardio:
        isCardioBtnSelected.value = true;
        isWorkoutBtnSelected.value = false;
        isRepairBtnSelected.value = false;
        break;
      case ActionType.repair:
        isRepairBtnSelected.value = true;
        isCardioBtnSelected.value = false;
        isWorkoutBtnSelected.value = false;
        break;
    }
    cardContainerHeight.value = 290;
  }

  void gotoStratWorkOut() {
    Get.toNamed(Routes.WORKOUT);
  }
}
