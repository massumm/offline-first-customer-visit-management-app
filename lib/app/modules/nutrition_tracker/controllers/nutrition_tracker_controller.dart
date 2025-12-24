import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/nutrition_tracker/models/meal_response_model.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository.dart';

import '../../../routes/app_pages.dart';
import '../models/meal_item.dart';

class NutritionTrackerController extends BaseController {
  final RxBool isOpened = false.obs;
  final RxDouble height = 0.0.obs;
  final double openedHeight = Get.height;
  final RxDouble cardContainerHeight = 0.0.obs;

  final mealNameController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final fatsController = TextEditingController();
  final carbsController = TextEditingController();

  final RxList<Meal> allMeals = <Meal>[].obs;
  final RxBool isLoading = false.obs;

  Meal? editingMeal;
  final RxBool isEditMode = false.obs;

  final MealRepository _mealRepository = Get.find(
    tag: (MealRepository).toString(),
  );

  RxInt quantity = 1.obs;

  // -------------------- INIT --------------------

  @override
  void onInit() {
    super.onInit();

    ever(isOpened, (bool opened) {
      height.value = opened ? openedHeight : 0.0;
      cardContainerHeight.value = opened ? 290 : 0.0;
    });
    print("NutritionTrackerController.onInit()");
    _checkEditMode();
    fetchMeals();
  }

  // -------------------- FETCH --------------------

  Future<void> fetchMeals() async {
    try {
      isLoading.value = true;
      final MealsResponse data = await _mealRepository.getMeals();
      allMeals.value = data.results ?? [];

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load meals',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- EDIT MODE --------------------

  void _checkEditMode() {
    if (Get.arguments != null && Get.arguments is Meal) {
      editingMeal = Get.arguments as Meal;
      isEditMode.value = true;

      mealNameController.text = editingMeal!.name;
      caloriesController.text = editingMeal!.calorieCount.toString();
      proteinController.text = editingMeal!.proteinGrams.toString();
      fatsController.text = editingMeal!.fatGrams.toString();
      carbsController.text = editingMeal!.carbohydrateGrams.toString();
    }
  }

  // -------------------- ACTIONS --------------------

  void onManualCardTap() {
    Get.toNamed(Routes.NUTRITION_TRACKER_ENTRY);
  }

  void incrementQty() => quantity.value++;

  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }


  // -------------------- DISPOSE --------------------

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

