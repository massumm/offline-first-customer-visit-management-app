import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

class TrackYourProgressAnimated extends StatefulWidget {
  const TrackYourProgressAnimated({super.key});

  @override
  State<TrackYourProgressAnimated> createState() =>
      _TrackYourProgressAnimatedState();
}

class _TrackYourProgressAnimatedState extends State<TrackYourProgressAnimated>
    with TickerProviderStateMixin {
  static const Duration animationDuration = Duration(
    seconds: 1,
    milliseconds: 500,
  );

  late AnimationController _bgController;
  late AnimationController _progressController;
  late AnimationController _stepsController;
  late AnimationController _performanceController;

  late Animation<double> _bgScale;
  late Animation<double> _progressScale;
  late Animation<double> _stepsScale;
  late Animation<double> _performanceScale;

  late final _assets = _buildAssets();

  Map<String, String> _buildAssets() {
    return {
      'bg': Get.isDarkMode
          ? Assets.splashScreenDarkBg
          : Assets.splashScreenLightBg,
      'page2Progress': Get.isDarkMode
          ? Assets.splashScreenDarkPage2Progress
          : Assets.page2Progress,
      'page2Steps': Get.isDarkMode
          ? Assets.splashScreenDarkPage2Steps
          : Assets.page2Steps,
      'page2Performance': Get.isDarkMode
          ? Assets.splashScreenDarkPage2Performance
          : Assets.page2Performance,
    };
  }

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _progressController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _stepsController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _performanceController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _bgScale = _createScaleAnimation(controller: _bgController);
    _progressScale = _createScaleAnimation(
      controller: _progressController,
    );
    _stepsScale = _createScaleAnimation(
      controller: _stepsController,
    );
    _performanceScale = _createScaleAnimation(
      controller: _performanceController,
    );

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (mounted) _bgController.forward();
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _progressController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _stepsController.forward();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _performanceController.forward();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _progressController.dispose();
    _stepsController.dispose();
    _performanceController.dispose();
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
          left: 0,
          right: 0,
          child: ScaleTransition(
            scale: _progressScale,
            alignment: Alignment.topLeft,
            child: SvgPicture.asset(_assets['page2Progress']!),
          ),
        ),
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: ScaleTransition(
            scale: _stepsScale,
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(_assets['page2Steps']!),
          ),
        ),
        Positioned(
          bottom: -15,
          left: 5,
          right: 0,
          child: ScaleTransition(
            scale: _performanceScale,
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(_assets['page2Performance']!),
          ),
        ),
      ],
    );
  }
}
