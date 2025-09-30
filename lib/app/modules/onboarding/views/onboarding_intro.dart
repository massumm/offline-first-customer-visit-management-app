import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

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
              _BackPill(onTap: () => Navigator.maybePop(context)),
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
                        fontSize: (theme.textTheme.bodyLarge!.fontSize ?? 16) + 8,
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
                        fontSize: (theme.textTheme.bodyLarge!.fontSize ?? 16) + 8,
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
                "This won’t take long. Each question is just one or two taps, and you’ll see your progress as you go",
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
                    // TODO: navigate to the first question
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

class _BackPill extends StatelessWidget {
  const _BackPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
