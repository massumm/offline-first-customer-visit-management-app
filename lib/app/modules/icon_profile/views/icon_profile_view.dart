import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/icon_profile_controller.dart';

class IconProfileView extends BaseView<IconProfileController> {
  const IconProfileView({super.key});

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          // Optional: for a cleaner look
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          pinned: true,
          title: Text('Icon Details', style: textTheme.titleMedium),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            // Ensure ActionPill is also theme-aware.
            child: ActionButton(onTap: () => Navigator.of(context).pop()),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image assets don't need theme changes.
                  Image.asset(Assets.iconProfileFirst),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mish Choudhury', style: textTheme.headlineMedium),
                      Row(
                        children: [
                          SvgPicture.asset(Assets.svgStar),
                          4.width,
                          Text('4.9', style: textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                  8.height,
                  Text('Mascot Icon', style: textTheme.bodyMedium),
                  8.height,
                  Text(
                    'I am a certified trainer with years of experience helping people transform their health and lifestyle. I have helped hundreds of emergency service workers improve their fitness, and am a fitness author.\n\nI specialise in supporting beginners, with a focus on rewiring your psychology to make fitness easier and more enjoyable!',
                    style: textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  8.height,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            // 5. Use surface colors for containers.
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text('Clients', style: textTheme.titleSmall),
                              Text(
                                '24+',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
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
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text('Exp.', style: textTheme.titleSmall),
                              Text(
                                '10+',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Text('Training Style', style: textTheme.headlineMedium),
                  8.height,
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildTrainingChip(context, 'Motivational'),
                          8.width,
                          _buildTrainingChip(context, 'Empathetic'),
                          8.width,
                          _buildTrainingChip(context, 'Supportive'),
                        ],
                      ),
                      8.height,
                      Row(
                        children: [
                          _buildTrainingChip(context, 'Patient'),
                          8.width,
                          _buildTrainingChip(context, 'Tough-Love'),
                          8.width,
                          _buildTrainingChip(context, 'Tactical'),
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  Text('Training Specialisms', style: textTheme.headlineMedium),
                  8.height,
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildTrainingChip(context, 'Strength'),
                          8.width,
                          _buildTrainingChip(context, 'Bodybuilding'),
                          8.width,
                          _buildTrainingChip(context, 'Scientific'),
                        ],
                      ),
                      8.height,
                      Row(
                        children: [
                          _buildTrainingChip(context, 'Holistic'),
                          8.width,
                          _buildTrainingChip(context, 'Fat-loss'),
                          8.width,
                          _buildTrainingChip(context, 'All-rounder'),
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  Image.asset(Assets.iconProfileSecond),
                  16.height,
                  _questionAnswers(
                    context: context,
                    title: 'The One this I always include in a program...',
                    description:
                        'Structured Progression, No guesswork. You earn every result.',
                  ),
                  16.height,
                  Image.asset(Assets.iconProfileThird),
                  16.height,
                  _questionAnswers(
                    context: context,
                    title: 'My proudest fitness moment was when...',
                    description: 'Joe Wicks complimented my biceps!',
                  ),
                  16.height,
                  Image.asset(Assets.iconProfileFourth),
                  16.height,
                  _questionAnswers(
                    context: context,
                    title: '— Alex Johnson',
                    description:
                        '"Structured progression. no guesswork. you earn every result."',
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildSocialMediaIcons(context),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  // Pass BuildContext to helper methods to access the theme.
  List<Widget> _buildSocialMediaIcons(BuildContext context) {
    final theme = Theme.of(context);
    final socialIcons = [
      FontAwesomeIcons.facebook,
      FontAwesomeIcons.instagram,
      FontAwesomeIcons.twitter,
      FontAwesomeIcons.linkedin,
    ];

    final List<Widget> iconWidgets = [];

    for (int i = 0; i < socialIcons.length; i++) {
      iconWidgets.add(
        Center(
          child: FaIcon(
            socialIcons[i],
            color: theme.colorScheme.onSurface,
            size: 36,
          ),
        ),
      );

      if (i < socialIcons.length - 1) {
        iconWidgets.add(16.width);
      }
    }

    return iconWidgets;
  }

  Container _questionAnswers({
    required BuildContext context,
    required String title,
    TextStyle? titleStyle,
    required String description,
    TextStyle? descriptionStyle,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle ?? textTheme.bodyMedium),
          8.height,
          Text(
            description,
            style:
                descriptionStyle ??
                textTheme.headlineMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingChip(BuildContext context, String text) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Expanded(
      child: SizedBox(
        height: 40,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            // Use a container color that works on both light and dark themes.
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(text, style: textTheme.bodyLarge)),
        ),
      ),
    );
  }
}
