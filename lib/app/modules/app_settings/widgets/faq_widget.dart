import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class FaqWidget extends BaseView<AppSettingsController> {
  const FaqWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  Widget body(BuildContext context) {
    final faqList = [
      {
        "Question": "How does the app track my steps and workouts?",
        "Answer":
            "The app uses your phone's built-in sensors and connected wearables (like smartwatches or fitness bands) to track steps, workouts, calories, and heart rate.",
      },
      {
        "Question": "Can I use the app without a wearable device?",
        "Answer":
            "Yes, you can use the app without a wearable device. Your phone's built-in sensors will track basic activities like steps and distance, though some advanced features may require a connected device.",
      },
      {
        "Question": "How do I set or change my fitness goals?",
        "Answer":
            "Go to Settings > Goals to set or modify your fitness targets. You can customize daily step goals, workout frequency, calorie targets, and more based on your personal fitness objectives.",
      },
      {
        "Question": "How do streaks and xp levels work?",
        "Answer":
            "Streaks track consecutive days you meet your goals, while XP (Experience Points) are earned by completing activities and challenges. As you gain XP, you level up and unlock new achievements and rewards.",
      },
      {
        "Question": "Can I share my progress with friends?",
        "Answer":
            "Yes! You can share your progress, achievements, and workout summaries with friends through the app. Go to Settings > Social to connect with friends and enable sharing features.",
      },
    ];

    // Initialize FAQ expansion states
    controller.initializeFaqExpansionStates(faqList.length);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FAQ',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          16.height,
          ...faqList.asMap().entries.map(
            (entry) => Column(
              children: [
                _buildFaqItem(
                  entry.value["Question"] ?? "",
                  entry.value["Answer"] ?? "",
                  entry.key,
                  controller.faqExpansionStates[entry.key],
                ),
                if (entry.key != faqList.length - 1) 8.height,
              ],
            ),
          ),
          16.height,
        ],
      ),
    );
  }

  Widget _buildFaqItem(
    String question,
    String answer,
    int index,
    bool isExpanded,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.cardColorWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question,
                  style: AppTextTheme.bodyLargeMedium.copyWith(
                    color: ThemeHelpers.primaryTextColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () => controller.toggleFaqExpansion(index),
                child: AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    Assets.activityTrackerDropdownUpIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      ThemeHelpers.primaryTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          4.height,
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Text(
                    answer,
                    style: AppTextTheme.bodySmallRegular.copyWith(
                      color: ThemeHelpers.secondaryTextColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
