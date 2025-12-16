import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/weekly_routine/controllers/weekly_routine_controller.dart';
import 'package:icon/app/modules/weekly_routine/widgets/added_exercise_card.dart';
import 'package:icon/generated/assets.dart';

class ExploreView extends BaseView<WeeklyRoutineController> {
  const ExploreView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(
          child: ActionButton(onTap: () => Navigator.maybePop(context)),
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
      child: Column(
        children: [
          Expanded(
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
                    onChanged: (value) => controller.searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: AppTextTheme.bodyLargeRegular.copyWith(
                        color: AppColors.hintTextColor,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          Assets.svgSearchIcon,
                          colorFilter: ColorFilter.mode(
                            AppColors.lightIconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  16.height,
                  // list of exercises
                  Obx(() => Column(
                    children: controller.filteredExercises.map((exercise) {
                      return InkWell(
                        onTap: () => controller.addExerciseToRoutine(exercise),
                        child: AddedExerciseCard(
                          exercise: exercise,
                          controller: controller,
                          showEditAndDeleteIcons: false,
                          showRoutinesCount: true,
                          showEquipmentType: true,
                        ),
                      );
                    }).toList(),
                  )),
                  // 32.height,
                ],
              ),

            ),
          ),
          16.height,
          LoadingButton(onPressed: () {}, label: 'Show All Programs', backgroundColor: AppColors.bgColorRed,)
        ],
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
