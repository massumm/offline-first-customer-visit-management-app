import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/nutrition_tracker/controllers/nutrition_tracker_controller.dart';
import '../../../core/values/app_text_styles.dart' as appBarTheme;
import '../../../core/widgets/action_button.dart';
import '../../../core/widgets/custom_app_bar.dart';

class NutritionTrackerEntryView
    extends GetView<NutritionTrackerController> {
  const NutritionTrackerEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:

      AppBar(
        title: Text('Add New Meal', style: appBarTheme.titleTextStyle),
        centerTitle: true,

        leading: Padding(
          padding: EdgeInsets.all(6),
          child: ActionButton.compact(onTap: Get.back),
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
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCaloriesCard(
                    title: 'Calories',
                    controller: controller.caloriesController,
                    hint: '548',
                    subtitle: 'Per meal',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMacroCard(
                          title: 'Protein',
                          controller: controller.proteinController,
                          hint: '27g',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMacroCard(
                          title: 'Fats',
                          controller: controller.fatsController,
                          hint: '3g',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMacroCard(
                          title: 'Carbs',
                          controller: controller.carbsController,
                          hint: '32g',
                        ),
                      ),
                    ],
                  ),
                ]
            ),
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

  // 2. Added the _label helper widget
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 3. Added the _input helper widget for the text field
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
        suffixStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey.shade900,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // New Widget for the main Calories card
  Widget _buildCaloriesCard({
    required String title,
    required TextEditingController controller,
    required String subtitle,
    String? hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              const Icon(Icons.edit, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Use an intrinsic width to allow the textfield to be inline
              IntrinsicWidth(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 28, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4), // Align with text baseline
                child: Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // New Widget for the smaller Protein, Fats, and Carbs cards
  Widget _buildMacroCard({
    required String title,
    required TextEditingController controller,
    String? hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const Icon(Icons.edit, color: Colors.white, size: 16),
            ],
          ),
          const SizedBox(height: 4),
          // Use a TextField that looks like simple text
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 22, fontWeight: FontWeight.bold),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              suffixText: 'g', // Add the 'g' unit here
              suffixStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }


  Widget _quantitySelector() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quantity',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _qtyButton(
                  icon: Icons.remove,
                  onTap: controller.decrementQty,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "${controller.quantity.value}x",
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
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: Colors.white),
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
          backgroundColor: AppColors.deepGreenFavBgColor,
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
