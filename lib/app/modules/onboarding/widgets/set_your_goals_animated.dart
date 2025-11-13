import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

import '../../../../generated/assets.dart';

/// Helper function to create a scale animation with elastic curve
Animation<double> _createScaleAnimation({
  required AnimationController controller,
  double begin = 0.0,
  double end = 1.0,
  Curve curve = Curves.elasticOut,
}) {
  return Tween<double>(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: curve));
}

class SetYourGoalsAnimated extends StatefulWidget {
  const SetYourGoalsAnimated({super.key});

  @override
  State<SetYourGoalsAnimated> createState() => _SetYourGoalsAnimatedState();
}

class _SetYourGoalsAnimatedState extends State<SetYourGoalsAnimated>
    with TickerProviderStateMixin {
  static const Duration animationDuration = Duration(
    seconds: 1,
    milliseconds: 500,
  );

  late AnimationController _bgController;
  late AnimationController _topRowController;
  late AnimationController _currentProgressController;
  late AnimationController _strengthTrainingController;

  late Animation<double> _bgScale;
  late Animation<double> _topRowScale;
  late Animation<double> _currentProgressScale;
  late Animation<double> _strengthTrainingScale;

  late final _assets = _buildAssets();

  Map<String, String> _buildAssets() {
    return {
      'bg': Get.isDarkMode
          ? Assets.splashScreenDarkBg
          : Assets.splashScreenLightBg,
      'page1Duration': Get.isDarkMode
          ? Assets.splashScreenDarkPage1Duration
          : Assets.splashScreenLightPage1Duration,
      'page1XpCompletion': Get.isDarkMode
          ? Assets.splashScreenDarkPage1XpCompletion
          : Assets.splashScreenLightPage1XpCompletion,
      'page1BodyFatGoal': Get.isDarkMode
          ? Assets.splashScreenDarkPage1BodyFatGoal
          : Assets.splashScreenLightPage1BodyFatGoal,
      'page1CurrentProgress': Get.isDarkMode
          ? Assets.splashScreenDarkPage1CurrentProgress
          : Assets.page1CurrentProgress,
      'page1StrengthTraining': Get.isDarkMode
          ? Assets.splashScreenDarkPage1StrengthTraining
          : Assets.page1StrengthTraining,
    };
  }

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _topRowController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _currentProgressController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _strengthTrainingController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _bgScale = _createScaleAnimation(controller: _bgController);
    _topRowScale = _createScaleAnimation(
      controller: _topRowController,
      end: 1.2,
    );
    _currentProgressScale = _createScaleAnimation(
      controller: _currentProgressController,
    );
    _strengthTrainingScale = _createScaleAnimation(
      controller: _strengthTrainingController,
    );

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (mounted) _bgController.forward();
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _topRowController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _currentProgressController.forward();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _strengthTrainingController.forward();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _topRowController.dispose();
    _currentProgressController.dispose();
    _strengthTrainingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScaleTransition(
          scale: _bgScale,
          alignment: Alignment.center,
          child: SvgPicture.asset(_assets['bg']!),
        ),
        Positioned(
          top: 50,
          left: 19,
          child: ScaleTransition(
            scale: _topRowScale,
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Image.asset(_assets['page1Duration']!),
                10.width,
                Image.asset(_assets['page1XpCompletion']!),
                10.width,
                Image.asset(_assets['page1BodyFatGoal']!),
              ],
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: ScaleTransition(
            scale: _currentProgressScale,
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(_assets['page1CurrentProgress']!),
          ),
        ),
        Positioned(
          bottom: -15,
          left: 5,
          right: 0,
          child: ScaleTransition(
            scale: _strengthTrainingScale,
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(_assets['page1StrengthTraining']!),
          ),
        ),
      ],
    );
  }
}
