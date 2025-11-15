import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/full_body_tracker/widgets/exercise_card.dart';
import 'package:icon/app/modules/weekly_routine/controllers/weekly_routine_controller.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:icon/generated/assets.dart';

class AddExerciseToRoutineView extends BaseView<WeeklyRoutineController> {
  const AddExerciseToRoutineView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionPill(onTap: () => Get.back())),
      ),
      title: Text('Add Exercise'),
      centerTitle: true,
      // add bottom floating button
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      final routine = controller.routines.firstWhere(
        (routine) => routine.day == controller.selectedDay.value,
      );
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
                  routine.workOuts.map((exercise) => _addedExerciseCard(exercise))
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


  Widget _addedExerciseCard(ExerciseModel exercise){
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ThemeHelpers.primaryCardColor,
      ),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ThemeHelpers.secondaryCardColor,
            ),
            child: Image.asset(
              Get.isDarkMode ? exercise.darkAsset : exercise.lightAsset,
              fit: BoxFit.contain,
            ),
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exercise.name, style: AppTextTheme.titleSmallSemiBold.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),),
              8.height,
              if(exercise.bodyAreaList != null && exercise.bodyAreaList!.isNotEmpty)
              Text(
                exercise.bodyAreaList!.map((bodyArea) => bodyArea.displayName).join(', '),
                style: AppTextTheme.bodyLargeRegular.copyWith(
                  color: ThemeHelpers.secondaryTextColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              InkWell(onTap: () => _editExercise(exercise), child: SvgPicture.asset(Assets.fullBodyTrackerEditIcon)),
              16.width,
              InkWell(
                onTap: () => _deleteExercise(exercise),
                  child: SvgPicture.asset(Assets.fullBodyTrackerDeleteIcon)),
            ],
          )
        ],
      ),
    );
  }

  void _editExercise(ExerciseModel exercise) {}

  void _deleteExercise(ExerciseModel exercise) {
    final currentRoutine = controller.routines.firstWhere(
      (routine) => routine.day == controller.selectedDay.value,
    );
    
    // Remove the exercise from the current routine
    currentRoutine.workOuts.removeWhere((existingExercise) => 
      existingExercise.name == exercise.name
    );
  }
}
