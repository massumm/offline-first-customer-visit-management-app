import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../../core/widgets/action_pill.dart';
import '../../../routes/app_pages.dart';

class OnboardingIntro extends StatelessWidget {
  const OnboardingIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button (small rounded square)
              ActionPill(onTap: () => Navigator.maybePop(context)),
              Spacer(),

              // Tiny orange kicker
              Text(
                "Let's build a plan for you, together",
                style: theme.textTheme.titleSmall!.copyWith(
                  color: AppColors.colorPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Headline with accent highlights
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Your Icon will become your '),
                    TextSpan(
                      text: 'personal coach',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize:
                            (theme.textTheme.bodyLarge!.fontSize ?? 16) + 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' - but first, it needs to know you - the more detail you share now, the smarter and more ',
                    ),
                    TextSpan(
                      text: 'personalised your plan',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize:
                            (theme.textTheme.bodyLarge!.fontSize ?? 16) + 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' will be.'),
                  ],
                ),

                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: (theme.textTheme.bodyLarge!.fontSize ?? 16) + 8,
                ),
              ),

              const SizedBox(height: 16),

              // Supporting copy
              Text(
                "This won’t take long. Each question is just one or two taps,"
                " and you’ll see your progress as you go",
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: AppColors.subTextColor,
                ),
              ),

              24.height,

              // Bottom primary action, pinned above the safe area
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.TRAINEE_ONBOARDING);
                  },
                  child: const Text(
                    "Let's begin",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
