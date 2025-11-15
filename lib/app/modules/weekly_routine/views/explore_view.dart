import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/weekly_routine/controllers/weekly_routine_controller.dart';

class ExploreView extends BaseView<WeeklyRoutineController> {
  const ExploreView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(
          child: ActionPill(onTap: () => Navigator.maybePop(context)),
        ),
      ),
      title: const Text('Explore'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Programs',
              style: AppTextTheme.titleSmallMedium.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),
            ),
            16.height,
            // text field for search
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextTheme.bodyLargeRegular.copyWith(
                  color: ThemeHelpers.primaryTextColor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: ThemeHelpers.primaryTextColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ThemeHelpers.primaryTextColor,
                  ),
                ),
              ),
            ),
            16.height,
            // list of exercises
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.availableExercises.length,
              itemBuilder: (context, index) {
                final exercise = controller.availableExercises[index];
                return ListTile(
                  onTap: () => _addExerciseToRoutine(exercise),
                  title: Text(exercise.name),
                  leading: Image.asset(exercise.lightAsset),
                  trailing: const Icon(Icons.add),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addExerciseToRoutine(ExerciseModel exercise) {
    final currentRoutine = controller.routines.firstWhere(
      (routine) => routine.day == controller.selectedDay.value,
    );
    
    // Check if exercise already exists in the current routine
    final isAlreadyAdded = currentRoutine.workOuts.any((existingExercise) => 
      existingExercise.name == exercise.name
    );
    
    if (isAlreadyAdded) {
      debugPrint('Exercise already added: ${exercise.name}');
    } else {
      // Add exercise to the current routine
      currentRoutine.workOuts.add(exercise);
      debugPrint('Exercise added: ${exercise.name}');
    }
  }
}
