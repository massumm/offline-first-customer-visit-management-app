import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/modules/weekly_routine/controllers/weekly_routine_controller.dart';
import 'package:icon/app/modules/weekly_routine/widgets/added_exercise_card.dart';
import 'package:icon/app/routes/app_pages.dart';

class AddExerciseToRoutineView extends BaseView<WeeklyRoutineController> {
  const AddExerciseToRoutineView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionButton(onTap: () => Get.back())),
      ),
      title: Text('Add Exercise'),
      centerTitle: true,
      // add bottom floating button
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      // Check which week is selected first
      if (controller.selectedWeek.value < 0 || controller.selectedWeek.value >= controller.weeks.length) {
        return Center(
          child: Text(
            'Invalid week selected',
            style: AppTextTheme.bodyLargeRegular,
          ),
        );
      }

      final currentWeek = controller.weeks[controller.selectedWeek.value];
      final routine = currentWeek.routines.firstWhereOrNull(
        (routine) => routine.day == controller.selectedDay.value,
      );

      if (routine == null) {
        return Center(
          child: Text(
            'No routine found for selected day',
            style: AppTextTheme.bodyLargeRegular,
          ),
        );
      }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${
              controller.selectedDay.value.displayName
            } Workout',
              style: AppTextTheme.titleMediumSemiBold,
            ),
        
            16.height,
            Text(
              'Plan and track your Monday training. Add exercises, remove ones you don’t need, or create custom workouts that fit your goals.',
              style: AppTextTheme.bodyLargeRegular,
            ),
            16.height,
            Column(
              children:
                  routine.workOuts.map((exercise) => AddedExerciseCard(exercise:  exercise, controller:  controller))
                  .toList(),
            )
          ],
        ),
      ),
    );
  });
  }

  @override
  Widget? floatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _addExercise(),
      backgroundColor: AppColors.bgColorRed,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _addExercise() {
    Get.toNamed(Routes.EXPLORE);
  }





}
