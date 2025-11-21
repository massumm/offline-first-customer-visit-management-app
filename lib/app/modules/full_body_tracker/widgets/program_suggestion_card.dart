import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/full_body_tracker/constants/program_data.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/full_body_tracker/widgets/themed_card.dart';
import 'package:icon/generated/assets.dart';

class ProgramSuggestionCard extends StatelessWidget {
  const ProgramSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ThemedCard(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ProgramData.intermediateProgram.title,
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          16.height,
          Row(
            children: [
              Image.asset(ProgramData.intermediateProgram.creatorIconPath, height: 24, width: 24),
              8.width,
              Text(
                ProgramData.intermediateProgram.creator,
                style: AppTextTheme.bodyLargeSemiBold.copyWith(
                  color: ThemeHelpers.primaryTextColor,
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
            ProgramData.intermediateProgram.description,
            style: AppTextTheme.bodyLargeRegular,
            textAlign: TextAlign.center,
          ),
          16.height,
          _buildProgramTags(),
        ],
      ),
    ));
  }

  Widget _buildProgramTags() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _programTagWidget(
                title: ProgramData.intermediateProgram.tags[0],
                asset: Assets.activityTrackerGym,
              ),
            ),
          ],
        ),
        8.height,
        Row(
          children: [
            Expanded(
              child: _programTagWidget(
                title: ProgramData.intermediateProgram.tags[1],
                asset: Assets.activityTrackerGym,
              ),
            ),
            8.width,
            Expanded(
              child: _programTagWidget(
                title: ProgramData.intermediateProgram.tags[2],
                asset: Assets.activityTrackerGym,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _programTagWidget({required String title, required String asset}) {
    return ThemedCard.secondary(
      child: Column(
        children: [
          SvgPicture.asset(
            asset,
            colorFilter: ColorFilter.mode(
              ThemeHelpers.primaryTextColor,
              BlendMode.srcIn,
            ),
          ),
          8.height,
          Text(
            title,
            style: AppTextTheme.bodyMediumSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
