import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            const SizedBox(height: 16),

            // --------- TABS  ---------
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.tabs.length,
                itemBuilder: (context, index) {
                  final title = controller.tabs[index];
                  final isSelected = controller.selectedTabIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.selectTab(index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? kAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kAccent, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : kAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
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
              child: SizedBox(
                width: double.infinity,
                height: 52,
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
