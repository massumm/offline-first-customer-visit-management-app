import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../controllers/your_daily_goals_controller.dart';

class YourDailyGoalsView extends GetView<YourDailyGoalsController> {
  const YourDailyGoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    const kBackground = Color(0xFF0F0F0F);
    const kAccent = Color(0xFFE44933);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Your Daily Goals",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Here are your daily goals - created for you, your lifestyle, and your fitness ambitions",
                style: TextStyle(
                  color: AppColors.darkTextSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --------- TABS  ---------
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.tabs.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final title = controller.tabs[index];
                  // Wrap only the ChoiceChip in an Obx
                  return Obx(() {
                    final isSelected =
                        controller.selectedTabIndex.value == index;
                    return ChoiceChip(
                      label: Text(title),
                      selected: isSelected,
                      onSelected: (_) {
                        controller.selectTab(index);
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : kAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.transparent,
                      selectedColor: kAccent,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: kAccent, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 12),

            // --------- GOAL LIST  ---------
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredGoals.length,
                  itemBuilder: (_, index) {
                    final goal = controller.filteredGoals[index];
                    return GoalCard(
                      title: goal.title,
                      value: goal.value,
                      description: goal.description,
                      frequency: goal.frequency,
                      color: goal.color,
                      icon: goal.icon, // Pass the dynamic icon
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// UPDATE GOAL CARD TO ACCEPT AN ICON
class GoalCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final String frequency;
  final Color color;
  final IconData icon; // Add icon property

  const GoalCard({
    super.key,
    required this.title,
    required this.value,
    required this.description,
    required this.frequency,
    required this.color,
    required this.icon, // Make it required
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22), // Use the dynamic icon
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              frequency,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
