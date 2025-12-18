import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';

import '../../../../generated/assets.dart';
import '../../../core/enums/fav_enum.dart';
import '../../../core/widgets/fab_widgets/animated_fab.dart';
import '../../../core/widgets/fab_widgets/animated_fab_card.dart';
import '../../../core/widgets/fab_widgets/fab_card_item.dart';
import '../controllers/nutrition_tracker_controller.dart';

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

          _mealTile(title: 'Meal 1', subtitle: '350 kcal • 8:10 am'),
          const SizedBox(height: 8),
          _mealTile(title: 'Meal 2', subtitle: '350 kcal • 8:10 am'),
        ],
      ),
    );
  }

  Widget _mealTile({required String title, required String subtitle}) {
    return Container(
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
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        title: const Text('Nutrition tracker'),
      ),

      floatingActionButton: AnimatedFab(
        actionType: FabActionType.addMeal,
        isOpen: controller.isOpened,
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [_nutritionLogCard()]),
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
                  ),
                  FabCardItem(
                    title: "Barcode Scanner",
                    source: SuperIconSource.imageAsset(
                      Assets.nutritionTrackerQrCode,
                    ),
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
                  ),
                  FabCardItem(
                    title: "Take Photo",
                    source: SuperIconSource.imageAsset(
                      Assets.nutritionTrackerCameraIcon,
                    ),
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
