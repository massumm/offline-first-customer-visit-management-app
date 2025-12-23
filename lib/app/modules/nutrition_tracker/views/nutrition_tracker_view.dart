import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/values/app_text_styles.dart' as appBarTheme;
import '../../../../generated/assets.dart';
import '../../../core/enums/fav_enum.dart';
import '../../../core/extensions/app_extansions.dart';
import '../../../core/widgets/action_button.dart';
import '../../../core/widgets/fab_widgets/animated_fab.dart';
import '../../../core/widgets/fab_widgets/animated_fab_card.dart';
import '../../../core/widgets/fab_widgets/fab_card_item.dart';
import '../../../core/widgets/super_widgets/super_icon_source.dart';
import '../../../routes/app_pages.dart';
import '../controllers/nutrition_tracker_controller.dart';
import '../models/meal_item.dart';

class NutritionTrackerView extends BaseView<NutritionTrackerController> {
  const NutritionTrackerView({super.key});

  Widget _nutritionLogCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Nutrition Log',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '12 min ago',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
                () {
              if (controller.isLoading.value) { // Assuming you have an isLoading RxBool
                return LinearProgressIndicator();
              }
              return _mealList(controller.allMeals);
            },
          ),
        ],
      ),
    );
  }
  Widget _mealList(List<Meal> meals) {
    if (meals.isEmpty) {
      return const Center(
        child: Text(
          'No meals logged yet!',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return Column(
      children: meals.map((meal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0), // Add spacing between tiles
          child: _mealTile(meal: meal),
        );
      }).toList(),
    );
  }
  Widget _mealTile({required Meal meal}) {
    final DateTime createdAt = meal.createdAt;

    // Format hour to 12-hour format
    final int hour = createdAt.hour % 12 == 0 ? 12 : createdAt.hour % 12;
    // Pad minute with leading zero if single digit
    final String minute = createdAt.minute.toString().padLeft(2, '0');
    // Determine AM or PM
    final String ampm = createdAt.hour < 12 ? 'AM' : 'PM';

    final String formattedTime = '$hour:$minute $ampm';
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.NUTRITION_TRACKER_ENTRY,
          arguments: meal,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name, // Use meal.name
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal.calorieCount} kcal • $formattedTime',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Image.asset(
              Assets.imagesArrowUpLeft,
              width: 20,
              height: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Nutrition Tracker', style: appBarTheme.titleTextStyle),
        centerTitle: true,

        leading: Padding(
          padding: EdgeInsets.all(6),
          child: ActionButton.compact(onTap: Get.back),
        ),
      ),


      // const CustomAppBar(
      //   title: 'Nutrition Tracker',
      //   // showBackButton is true by default, so you can omit it if you want it visible
      //   showBackButton: true,
      // ),

      floatingActionButton: AnimatedFab(
        actionType: FabActionType.addMeal,
        isOpen: controller.isOpened,
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [_nutritionLogCard()]),
            ),
          ),
          AnimatedFabCard(
            height: controller.height,
            cardContainerHeight: controller.cardContainerHeight,
            fabCards: [
              const Text(
                "Log Nutrition",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              12.height,
              Row(
                mainAxisAlignment: .spaceAround,
                spacing: 8,
                children: [
                  FabCardItem(
                    title: "Search",
                    source: SuperIconSource.imageAsset(
                      Assets.nutritionTrackerSearchIcon,
                    ),
                    onTap: () {},
                  ),
                  FabCardItem(
                    title: "Barcode Scanner",
                    source: SuperIconSource.imageAsset(
                      Assets.nutritionTrackerQrCode,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: .spaceAround,
                spacing: 8,
                children: [
                  FabCardItem(
                    title: "Manual",
                    source: SuperIconSource.imageAsset(
                      Assets.nutritionTrackerNotebookIcon,
                    ),
                    onTap: controller.onManualCardTap,
                  ),
                  FabCardItem(
                    title: "Take Photo",
                    source: SuperIconSource.imageAsset(
                      Assets.nutritionTrackerCameraIcon,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
