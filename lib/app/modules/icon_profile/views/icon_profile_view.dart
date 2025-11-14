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
          // expandedHeight: 300,
          // collapsedHeight: 300,
          // backgroundColor: AppColors.lightAppBarBgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          pinned: true,
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
                  Image.asset(Assets.iconProfileFirst),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mish Choudhury',
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
                  Text('Mascot Icon', style: AppTextTheme.bodyMediumRegular),
                  8.height,
                  Text(
                    'I am a certified trainer with years of experience helping people transform their health and lifestyle. I have helped hundreds of emergency service workers improve their fitness, and am a fitness author.\n\nI specialise in supporting beginners, with a focus on rewiring your psychology to make fitness easier and more enjoyable!',
                    style: AppTextTheme.titleSmallRegular.copyWith(
                      color: AppColors.lightTextSecondaryColor,
                    ),
                  ),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text:
                  //             'I am a certified fitness trainer with years of experience helping people transform their health and lifestyle. My approach combines personalized workout plans, balanced ',
                  //         style: AppTextTheme.titleSmallRegular.copyWith(
                  //           color: AppColors.lightTextSecondaryColor,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: 'Read more...',
                  //         style: AppTextTheme.titleSmallSemiBold.copyWith(
                  //           color: AppColors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                  // 16.height,
                  // _badges(),
                  16.height,

                  Text(
                    'Training Specialisms',
                    style: AppTextTheme.headlineMediumSemiBold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  8.height,
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
                  Image.asset(Assets.iconProfileSecond),
                  16.height,
                  _questionAnswers(
                    title: 'The One this I always include in a program...',
                    description:
                        'Structured Progression, No guesswork. You earn every result.',
                  ),
                  16.height,
                  Image.asset(Assets.iconProfileThird),
                  16.height,
                  _questionAnswers(
                    title: 'My proudest fitness moment was when...',
                    description: 'Joe Wicks complimented my biceps!',
                  ),
                  16.height,
                  Image.asset(Assets.iconProfileFourth),
                  16.height,
                  _questionAnswers(
                    title: '— Alex Johnson',
                    description:
                        '"Structured progression. no guesswork. you earn every result."',
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildSocialMediaIcons(),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSocialMediaIcons() {
    final socialIcons = [
      FontAwesomeIcons.facebook,
      FontAwesomeIcons.instagram,
      FontAwesomeIcons.twitter,
      FontAwesomeIcons.linkedin,
    ];

    final List<Widget> iconWidgets = [];

    for (int i = 0; i < socialIcons.length; i++) {
      iconWidgets.add(
        Center(child: FaIcon(socialIcons[i], color: AppColors.black, size: 36)),
      );

      if (i < socialIcons.length - 1) {
        iconWidgets.add(16.width);
      }
    }

    return iconWidgets;
  }

  Container _questionAnswers({
    required String title,
    TextStyle? titleStyle,
    required String description,
    TextStyle? descriptionStyle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                titleStyle ??
                AppTextTheme.bodyMediumSemiBold.copyWith(
                  color: AppColors.black,
                ),
          ),
          8.height,
          Text(
            description,
            style:
                descriptionStyle ??
                AppTextTheme.headlineMediumSemiBold.copyWith(
                  color: AppColors.black,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Row _badges() {
    return Row(
      children: [
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
