import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

import '../../../routes/app_pages.dart';

class NutritionTrackerController extends BaseController {
  final RxBool isOpened = false.obs;
  final RxDouble height = 0.0.obs;
  final double openedHeight = Get.height;
  final RxDouble cardContainerHeight = 0.0.obs;
  final mealNameController = TextEditingController();
  final caloriesController = TextEditingController(text: '548');
  final proteinController = TextEditingController(text: '27');
  final fatsController = TextEditingController(text: '3');
  final carbsController = TextEditingController(text: '32');
  @override
  void onInit() {
    super.onInit();
    ever(isOpened, (bool opened) {
      height.value = opened ? openedHeight : 0.0;
      cardContainerHeight.value = opened ? 290 : 0.0;
    });
  }
  void onManualCardTap() {
    Get.toNamed(Routes.NUTRITION_TRACKER_ENTRY);
  }



  RxInt quantity = 1.obs;

  void incrementQty() {
    quantity.value++;
  }

  void decrementQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void saveMeal() {
    // Business logic / API call
    Get.snackbar(
      'Saved',
      'Meal has been saved successfully',
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    mealNameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    fatsController.dispose();
    carbsController.dispose();
    super.onClose();
  }
}
