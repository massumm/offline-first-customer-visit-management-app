import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/full_body_tracker/controllers/full_body_tracker_controller.dart';
import 'package:icon/generated/assets.dart';

class FullBodyTrackerView extends BaseView<FullBodyTrackerController> {
  FullBodyTrackerView({super.key});

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
      child: SingleChildScrollView(
        child: Column(children: [_programSuggestion()]),
      ),
    );
  }

  Container _programSuggestion() {
    return Container(
      padding: const EdgeInsets.all(12),
      // height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intermediate Push/Pull/Legs (Gym Equipment)',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: AppColors.black,
            ),
          ),
          16.height,
          Row(
            children: [
              Image.asset(Assets.imagesMishIcon, height: 24, width: 24),
              8.width,
              Text(
                'Created by ICON',
                style: AppTextTheme.bodyLargeSemiBold.copyWith(
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          16.height,
          LoadingButton(
            onPressed: () {},
            label: 'Save Program',
            backgroundColor: AppColors.buttonColorRedPink,
          ),
          16.height,
          Text(
            'This intermediate program has three weekly workouts: push (chest, shoulders, and triceps), pull (back and biceps), and legs (quadriceps, hamstrings, glutes, and calves).',
            style: AppTextTheme.bodyLargeRegular,
            textAlign: TextAlign.center,
          ),
          16.height,
          Row(
            children: [
              Expanded(
                child: _gymWidget(
                  title: 'Gym',
                  asset: Assets.fullBodyTrackerGym,
                ),
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              Expanded(
                child: _gymWidget(
                  title: 'Gain Muscle',
                  asset: Assets.fullBodyTrackerGym,
                ),
              ),
              8.width,
              Expanded(
                child: _gymWidget(
                  title: '3 Routines',
                  asset: Assets.fullBodyTrackerGym,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gymWidget({required String title, required String asset}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightBgColorSecondary,
      ),
      child: Column(
        children: [
          SvgPicture.asset(asset),
          8.height,
          Text(
            title,
            style: AppTextTheme.bodyMediumSemiBold.copyWith(
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
