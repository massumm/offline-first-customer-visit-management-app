import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/modules/nutrition_tracker/controllers/nutrition_tracker_controller.dart';

class NutritionTrackerEntryView
    extends GetView<NutritionTrackerController> {
  const NutritionTrackerEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Add New Meal',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Meal Name'),
            _input(
              controller.mealNameController,
              hint: 'e.g. Protein Smoothie Bowl',
            ),
            const SizedBox(height: 16),

            _label('Calories'),
            _input(controller.caloriesController, suffix: 'kcal'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _macroInput(
                    title: 'Protein',
                    controller: controller.proteinController,
                    unit: 'g',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _macroInput(
                    title: 'Fats',
                    controller: controller.fatsController,
                    unit: 'g',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _macroInput(
                    title: 'Carbs',
                    controller: controller.carbsController,
                    unit: 'g',
                  ),
                ),
              ],
            ),

            const Spacer(),

            _quantitySelector(),

            const SizedBox(height: 16),

            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _input(
      TextEditingController controller, {
        String? hint,
        String? suffix,
      }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        suffixText: suffix,
        suffixStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _macroInput({
    required String title,
    required TextEditingController controller,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        _input(controller, suffix: unit),
      ],
    );
  }

  Widget _quantitySelector() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quantity',
            style: TextStyle(color: Colors.white),
          ),
          Row(
            children: [
              _qtyButton(
                icon: Icons.remove,
                onTap: controller.decrementQty,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  controller.quantity.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              _qtyButton(
                icon: Icons.add,
                onTap: controller.incrementQty,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.green),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: controller.saveMeal,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Save Meal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
