import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/exercise_strategy_training_style_screen.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/identity_verification_full_name.dart';

class TrainingPlansScreen extends GetView<TrainerOnboardingController> {
  const TrainingPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrainerOnboardingController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackPill(onTap: () => Navigator.maybePop(context)),
            30.height,
            const ProgressBar(currentStep: 2, stepText: "Exercise Strategy"),
            250.height,
            // Title
            Center(
              child: Text(
                "How do you build your training plans?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // fixed
                ),
              ),
            ),
            20.height,
            Expanded(
              child: Obx(
                    () => ReorderableListView.builder(
                  itemCount: controller.trainingPlanOptions.length,
                  onReorder: controller.reorderItems,
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final option = controller.trainingPlanOptions[index];
                    return Container(
                      key: ValueKey("$option-$index"), // ✅ always unique key
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: controller.selectedOption.value == index
                            ? Colors.deepOrange
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: controller.selectedOption.value == index
                                  ? Colors.white
                                  : Colors.deepOrange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: controller.selectedOption.value == index
                                    ? Colors.deepOrange
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          12.width,
                          ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_indicator_rounded, color: Colors.grey),
                          ),
                          12.width,
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(color: AppColors.subTextColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => ExerciseStrategyTrainingStyleScreen());
              },
              child: const Text('Next'),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
