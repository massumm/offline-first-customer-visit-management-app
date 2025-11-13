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

class ExpertCraftedIconsAnimated extends StatefulWidget {
  const ExpertCraftedIconsAnimated({super.key});

  @override
  State<ExpertCraftedIconsAnimated> createState() =>
      _ExpertCraftedIconsAnimatedState();
}

class _ExpertCraftedIconsAnimatedState extends State<ExpertCraftedIconsAnimated>
    with TickerProviderStateMixin {
  static const Duration animationDuration = Duration(
    seconds: 1,
    milliseconds: 500,
  );

  late AnimationController _bgController;
  late AnimationController _imageController;
  late AnimationController _ratingsController;

  late Animation<double> _bgScale;
  late Animation<double> _imageScale;
  late Animation<double> _ratingsScale;

  late final _assets = _buildAssets();

  Map<String, String> _buildAssets() {
    return {
      'bg': Get.isDarkMode ? Assets.splashScreenDarkPage3Bg : Assets.page3Bg,
      'page3Steps': Get.isDarkMode
          ? Assets.splashScreenDarkPage3Steps
          : Assets.splashScreenLightPage3Steps,
      'page3Ratings': Get.isDarkMode
          ? Assets.splashScreenDarkPage3Ratings
          : Assets.page3Ratings,
    };
  }

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _imageController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _ratingsController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _bgScale = _createScaleAnimation(controller: _bgController);
    _imageScale = _createScaleAnimation(controller: _imageController);
    _ratingsScale = _createScaleAnimation(controller: _ratingsController);

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (mounted) _bgController.forward();
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _imageController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ratingsController.forward();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _imageController.dispose();
    _ratingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ScaleTransition(
              scale: _bgScale,
              alignment: Alignment.center,
              child: SvgPicture.asset(_assets['bg']!),
            ),
          ),
          Positioned(
            top: 45,
            left: 40,
            child: ScaleTransition(
              scale: _imageScale,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 300,
                child: Image.asset(_assets['page3Steps']!, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: 230,
            left: 40,
            child: ScaleTransition(
              scale: _ratingsScale,
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(_assets['page3Ratings']!),
            ),
          ),
        ],
      ),
    );
  }
}
