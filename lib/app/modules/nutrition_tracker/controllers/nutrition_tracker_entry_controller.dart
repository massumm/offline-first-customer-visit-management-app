import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/nutrition_tracker/models/meal_item.dart'; // Assuming Meal is your single meal model
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository.dart';

class NutritionTrackerEntryController extends BaseController {
  final MealRepository _mealRepository = Get.find(tag: (MealRepository).toString());

  // Text editing controllers for the form fields
  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();

  // Quantity selector
  final RxInt quantity = 1.obs;

  // State for loading/saving
  final RxBool isLoading = false.obs;

  // For edit mode functionality
  final RxBool isEditMode = false.obs;
  Meal? editingMeal; // Holds the meal data if in edit mode

  @override
  void onInit() {
    super.onInit();
    // Initialize form fields to default values
    _resetFormFields();

    // Check if a Meal object was passed as an argument (for editing)
    if (Get.arguments != null && Get.arguments is Meal) {
      editingMeal = Get.arguments as Meal;
      _fillFormForEdit(editingMeal!);
      isEditMode.value = true;
    }
  }

  // Resets all form fields to their initial state
  void _resetFormFields() {
    mealNameController.text = '';
    caloriesController.text = '0';
    proteinController.text = '0';
    fatsController.text = '0';
    carbsController.text = '0';
    quantity.value = 1;
  }

  // Fills form fields with existing meal data for editing
  void _fillFormForEdit(Meal meal) {
    mealNameController.text = meal.name;
    caloriesController.text = meal.calorieCount.toString();
    proteinController.text = meal.proteinGrams.toString();
    fatsController.text = meal.fatGrams.toString();
    carbsController.text = meal.carbohydrateGrams.toString();
    // If quantity is part of your Meal model, populate it here as well
    // quantity.value = meal.quantity;
  }

  void incrementQty() {
    quantity.value++;
  }

  void decrementQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Refactored to use .then()
  void saveOrUpdateMeal() { // Removed 'async' keyword
    isLoading.value = true; // Set loading to true immediately

    Future<void> operation;

    if (isEditMode.value && editingMeal != null) {
      operation = _mealRepository.updateMeal(
        mealId: editingMeal!.id,
        name: mealNameController.text.trim(),
        calories: int.parse(caloriesController.text),
        protein: int.parse(proteinController.text),
        fats: int.parse(fatsController.text),
        carbs: int.parse(carbsController.text),
      );
    } else {
      operation = _mealRepository.createMeal(
        name: mealNameController.text.trim(),
        calories: int.parse(caloriesController.text),
        protein: int.parse(proteinController.text),
        fats: int.parse(fatsController.text),
        carbs: int.parse(carbsController.text),
      );
    }

    operation.then((_) {
      // Operation (create/update) successful. Now navigate back and show success.
      Get.back(); // Navigate back to the previous screen

    }).catchError((e) {
      // Any error in createMeal or updateMeal
      Get.snackbar(
        'Error',
        'Failed to save meal: ${e.toString()}',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }).whenComplete(() {
      // This block runs regardless of success or error, similar to 'finally'
      isLoading.value = false; // Hide loading indicator
    });
  }


  @override
  void onClose() {
    // Dispose all TextEditingControllers to prevent memory leaks
    mealNameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    fatsController.dispose();
    carbsController.dispose();
    super.onClose();
  }
}