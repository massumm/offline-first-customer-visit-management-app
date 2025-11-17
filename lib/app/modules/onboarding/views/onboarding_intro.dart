import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../../core/widgets/action_pill.dart';
import '../../../routes/app_pages.dart';

class OnboardingIntro extends StatefulWidget {
  const OnboardingIntro({super.key});

  @override
  State<OnboardingIntro> createState() => _OnboardingIntroState();
}

class _OnboardingIntroState extends State<OnboardingIntro> {
  // A state variable to control the sequence of animations.
  int _animationStep = 0;

  @override
  void initState() {
    super.initState();
    // Start the animation sequence after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _startAnimationSequence(),
    );
  }

  void _startAnimationSequence() {
    // A series of delayed futures to update the animation step.
    // Each setState call will trigger the next stage of the animation.
    const animationGap = Duration(milliseconds: 1200);
    const initialDelay = Duration(milliseconds: 400);

    Future.delayed(initialDelay, () {
      if (mounted) setState(() => _animationStep = 1);
    });
    Future.delayed(initialDelay + animationGap, () {
      if (mounted) setState(() => _animationStep = 2);
    });
    Future.delayed(initialDelay + (animationGap * 2), () {
      if (mounted) setState(() => _animationStep = 3);
    });
    Future.delayed(initialDelay + (animationGap * 3), () {
      if (mounted) setState(() => _animationStep = 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define initial (large) and final (small) text styles for animation.
    final kickerFinalStyle = theme.textTheme.titleMedium!.copyWith(
      color: Get.isDarkMode ? Colors.white : AppColors.colorPrimary,
    );
    final kickerInitialStyle = theme.textTheme.headlineMedium!.copyWith(
      color: Get.isDarkMode ? Colors.white : AppColors.colorPrimary,
    );

    final headlineFinalStyle = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: (theme.textTheme.bodyLarge!.fontSize ?? 16) + 12,
    );
    final headlineInitialStyle = theme.textTheme.headlineMedium!.copyWith(
      fontWeight: FontWeight.w700,
    );

    final supportingCopyFinalStyle = theme.textTheme.bodyMedium!;
    final supportingCopyInitialStyle = theme.textTheme.headlineSmall!.copyWith(
      color: supportingCopyFinalStyle.color,
    );


    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              AnimatedOpacity(
                opacity: _animationStep >= 1 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: ActionPill(onTap: () => Navigator.maybePop(context)),
              ),
              const SizedBox(height: 32),

              // Animated tiny orange kicker
              _AnimatedText(
                text: "Let's build a plan for you, together",
                initialStyle: kickerInitialStyle,
                finalStyle: kickerFinalStyle,
                animationStep: _animationStep,
                visibleAtStep: 1,
              ),
              const SizedBox(height: 12),

              // Animated headline with accent highlights
              _AnimatedText(
                isRichText: true,
                initialStyle: headlineInitialStyle,
                finalStyle: headlineFinalStyle,
                animationStep: _animationStep,
                visibleAtStep: 2,
                richTextChildren: [
                  const TextSpan(text: 'Your Icon will become your '),
                  TextSpan(
                    text: 'personal coach',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  const TextSpan(
                    text:
                        ' - but first, it needs to know you - the more detail you share now, the smarter and more ',
                  ),
                  TextSpan(
                    text: 'personalised your plan',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  const TextSpan(text: ' will be.'),
                ],
              ),

              const SizedBox(height: 16),

              // Animated supporting copy
              _AnimatedText(
                text:
                    "This won’t take long. Each question is just one or two taps,"
                    " and you’ll see your progress as you go",
                initialStyle: supportingCopyInitialStyle,
                finalStyle: supportingCopyFinalStyle,
                animationStep: _animationStep,
                visibleAtStep: 3,
              ),

              const Spacer(),
              AnimatedOpacity(
                opacity: _animationStep >= 4 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Padding(
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

class _AnimatedText extends StatelessWidget {
  const _AnimatedText({
    required this.initialStyle,
    required this.finalStyle,
    required this.animationStep,
    required this.visibleAtStep,
    this.text,
    this.isRichText = false,
    this.richTextChildren,
  });

  final TextStyle initialStyle;
  final TextStyle finalStyle;
  final int animationStep;
  final int visibleAtStep;
  final String? text;
  final bool isRichText;
  final List<TextSpan>? richTextChildren;

  @override
  Widget build(BuildContext context) {
    final bool isAnimated = animationStep >= visibleAtStep;
    const animationDuration = Duration(milliseconds: 800);
    const fadeInDuration = Duration(milliseconds: 400);

    return AnimatedOpacity(
      opacity: isAnimated ? 1.0 : 0.0,
      duration: fadeInDuration,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOutCubic,
        // Animate the alignment from center to left.
        alignment: isAnimated ? Alignment.centerLeft : Alignment.center,
        // Use a width of double.infinity to allow alignment to work.
        width: double.infinity,
        child: AnimatedDefaultTextStyle(
          duration: animationDuration,
          curve: Curves.easeInOutCubic,
          // Animate the style from initial (large) to final (small).
          style: isAnimated ? finalStyle : initialStyle,
          textAlign: isAnimated ? TextAlign.start : TextAlign.center,
          child: isRichText
              ? Text.rich(TextSpan(children: richTextChildren))
              : Text(text ?? ''),
        ),
      ),
    );
  }
}
