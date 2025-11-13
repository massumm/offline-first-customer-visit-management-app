import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/generated/assets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/icon_profile_controller.dart';

class IconProfileView extends BaseView<IconProfileController> {
  IconProfileView({super.key});

  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          collapsedHeight: 300,
          backgroundColor: AppColors.lightAppBarBgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          title: Text(
            'Icon Details',
            style: AppTextTheme.titleMediumSemiBold.copyWith(
              color: AppColors.black,
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ActionPill(onTap: () {}),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Your content here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ryan Johnson',
                        style: AppTextTheme.headlineMediumSemiBold.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(Assets.svgStar),
                          Text('4.9', style: AppTextTheme.bodyMediumRegular),
                        ],
                      ),
                    ],
                  ),
                  8.height,
                  Text(
                    'Lifting trainer',
                    style: AppTextTheme.bodyMediumRegular,
                  ),
                  8.height,
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'I am a certified fitness trainer with years of experience helping people transform their health and lifestyle. My approach combines personalized workout plans, balanced ',
                          style: AppTextTheme.titleSmallRegular.copyWith(
                            color: AppColors.lightTextSecondaryColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Read more...',
                          style: AppTextTheme.titleSmallSemiBold.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Clients',
                                style: AppTextTheme.titleSmallSemiBold.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                '24+',
                                style: AppTextTheme.titleSmallRegular.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      16.width,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Exp.',
                                style: AppTextTheme.titleSmallSemiBold.copyWith(
                                  color: AppColors.black,
                                ),
                              ),

                              Text(
                                '10+',
                                style: AppTextTheme.titleSmallRegular.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Text(
                    'Training Style',
                    style: AppTextTheme.headlineMediumSemiBold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  8.height,
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildTrainingChip('Motivational'),
                          8.width,
                          _buildTrainingChip('Empathetic'),
                          8.width,
                          _buildTrainingChip('Supportive'),
                        ],
                      ),
                      8.height,
                      Row(
                        children: [
                          _buildTrainingChip('Patient'),
                          8.width,
                          _buildTrainingChip('Tough-Love'),
                          8.width,
                          _buildTrainingChip('Tactical'),
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  Text(
                    'Badges',
                    style: AppTextTheme.headlineMediumSemiBold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  8.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          color: AppColors.lightAppBarBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  16.height,
                  Text(
                    'Training Specialisms',
                    style: AppTextTheme.headlineMediumSemiBold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  8.height,
                  // Strength
                  // Bodybuilding
                  // Scientific
                  // Holistic
                  // Fat-loss
                  // All-rounder
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildTrainingChip('Strength'),
                          8.width,
                          _buildTrainingChip('Bodybuilding'),
                          8.width,
                          _buildTrainingChip('Scientific'),
                        ],
                      ),
                      8.height,
                      Row(
                        children: [
                          _buildTrainingChip('Holistic'),
                          8.width,
                          _buildTrainingChip('Fat-loss'),
                          8.width,
                          _buildTrainingChip('All-rounder'),
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  Container(
                    height: 177,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightAppBarBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  16.height,
                  Text(
                    '— Alex Johnson',
                    style: AppTextTheme.headlineMediumSemiBold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  8.height,
                  Text(
                    '“Structured progression. no guesswork. you earn every result.”',
                    style: AppTextTheme.bodyLargeMedium.copyWith(
                      color: AppColors.lightTextSecondaryColor,
                    ),
                  ),
                  16.height,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.facebook,
                              color: AppColors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: Container(
                          height: 50,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.instagram,
                              color: AppColors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: Container(
                          height: 50,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.twitter,
                              color: AppColors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: Container(
                          height: 50,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.linkedin,
                              color: AppColors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingChip(String text) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.lightAppBarBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextTheme.bodyLargeMedium.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
