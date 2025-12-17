import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../core/enums/fav_enum.dart';
import '../../../core/widgets/fav_slide_animation.dart';

class NutritionTrackerView extends StatelessWidget {
  const NutritionTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
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

      floatingActionButton: AnimatedFab(actionType: FabActionType.addMeal),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _nutritionLogCard(),
          ],
        ),
      ),
    );
  }

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

          _mealTile(
            title: 'Meal 1',
            subtitle: '350 kcal • 8:10 am',
          ),
          const SizedBox(height: 8),
          _mealTile(
            title: 'Meal 2',
            subtitle: '350 kcal • 8:10 am',
          ),
        ],
      ),
    );
  }

  Widget _mealTile({
    required String title,
    required String subtitle,
  }) {
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
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.white),
        ],
      ),
    );
  }
}