import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/full_body_tracker/controllers/full_body_tracker_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/full_body_tracker/widgets/program_suggestion_card.dart';
import 'package:icon/app/modules/full_body_tracker/widgets/workout_card.dart';

class FullBodyTrackerView extends BaseView<FullBodyTrackerController> {
  const FullBodyTrackerView({super.key});

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
      title: Text('Full Body'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const ProgramSuggestionCard(),
                  16.height,
                  _workouts(),
                  8.height,
                ],
              ),
            ),
          ),
          8.height,
          LoadingButton(
            onPressed: () {},
            label: 'Save Program',
            backgroundColor: AppColors.buttonColorRedPink,
          ),
          16.height,
        ],
      ),
    );
  }

  Widget _workouts() {
    return Column(
      children: controller.workOuts
          .map((workout) => WorkoutCard(workout: workout))
          .toList(),
    );
  }
}
