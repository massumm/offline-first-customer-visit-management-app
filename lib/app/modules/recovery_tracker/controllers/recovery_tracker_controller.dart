import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import '../../../routes/app_pages.dart';

enum RecoveryActivityType {
  yoga,
  stretching,
  foamRolling,
  breathing,
  meditation,
  mobilityFlow,
  lightWalk,
  sauna,
  iceBath,
  massage,
  restorativeYoga,
  pilates,
  mindfulness,
}

extension RecoveryActivityTypeX on RecoveryActivityType {
  String get label {
    switch (this) {
      case RecoveryActivityType.yoga:
        return 'Yoga';
      case RecoveryActivityType.stretching:
        return 'Stretching';
      case RecoveryActivityType.foamRolling:
        return 'Foam Rolling';
      case RecoveryActivityType.breathing:
        return 'Breathing';
      case RecoveryActivityType.meditation:
        return 'Meditation';
      case RecoveryActivityType.mobilityFlow:
        return 'Mobility Flow';
      case RecoveryActivityType.lightWalk:
        return 'Light Walk';
      case RecoveryActivityType.sauna:
        return 'Sauna / Heat Therapy';
      case RecoveryActivityType.iceBath:
        return 'Ice Bath / Cold Exposure';
      case RecoveryActivityType.massage:
        return 'Massage / Self-Massage';
      case RecoveryActivityType.restorativeYoga:
        return 'Restorative Yoga';
      case RecoveryActivityType.pilates:
        return 'Pilates';
      case RecoveryActivityType.mindfulness:
        return 'Mindfulness Session';
    }
  }
}

class RecoveryTrackerController extends BaseController {
  /// ---------------- UI STATE ----------------
  final RxBool isOpened = false.obs;
  final RxDouble height = 0.0.obs;
  final RxDouble cardContainerHeight = 0.0.obs;
  final double openedHeight = Get.height;

  /// ---------------- FORM STATE ----------------
  final Rxn<RecoveryActivityType> selectedType =
  Rxn<RecoveryActivityType>();

  final TextEditingController durationController =
  TextEditingController(text: '20');

  /// ---------------- LIFECYCLE ----------------
  @override
  void onInit() {
    super.onInit();

    ever(isOpened, (bool opened) {
      height.value = opened ? openedHeight : 0.0;
      cardContainerHeight.value = opened ? 290 : 0.0;
    });
  }

  @override
  void onClose() {
    durationController.dispose();
    super.onClose();
  }

  /// ---------------- ACTIONS ----------------
  void onRecoveryEntryCardTap() {
    Get.toNamed(Routes.RECOVERY_TRACKER_ENTRY);
  }

  void onSelectActivityType(RecoveryActivityType? type) {
    selectedType.value = type;
  }

  void submitRecoveryLog() {
    if (selectedType.value == null) {
      Get.snackbar(
        'Missing Info',
        'Please select activity type',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    debugPrint('Activity: ${selectedType.value!.label}');
    debugPrint('Duration: ${durationController.text} min');

    // TODO: API / Repository call

    Get.back(); // optional
  }
}
