import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../core/values/app_colors.dart';

class IconicNavWrapper extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const IconicNavWrapper({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          /// NAV BAR
          Positioned(
            bottom: 0,
            left: 12,
            right: 12,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navItem(
                    selectedImage: Assets.svgHomeIcon,
                    unselectedImage: Assets.svgHomeIconGrey,
                    label: "Home",
                    index: 0,
                  ),
                  _navItem(
                    selectedImage: Assets.svgAnalysisIcon,
                    unselectedImage: Assets.svgAnalysisIconGrey,
                    label: "Analytic",
                    index: 1,
                  ),

                  /// EMPTY SPACE FOR CENTER BUTTON
                  const SizedBox(width: 62),

                  _navItem(
                    selectedImage: Assets.svgGroupIcon,
                    unselectedImage: Assets.svgGroupIconGrey,
                    label: "Community",
                    index: 3,
                  ),

                  /// PROFILE
                  _navProfile(index: 4),
                ],
              ),
            ),
          ),

          /// CENTER FLOATING BUTTON (Animated)
          Positioned(
            top: 0,
            child: AnimatedScale(
              scale: currentIndex == 2 ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              child: GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.lightBgColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 12),
                  ),
                  child: Center(child: SvgPicture.asset(Assets.svgIcon)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ANIMATED NAV ITEM
  /// ANIMATED NAV ITEM
  Widget _navItem({
    required String selectedImage,
    required String unselectedImage,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedScale(
        scale: isActive ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 300),
              tween: ColorTween(
                begin: Colors.white70,
                end: isActive ? Colors.red : Colors.white70,
              ),
              builder: (_, color, __) => SvgPicture.asset(
                isActive ? selectedImage : unselectedImage,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isActive ? 1.0 : 0.7,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: isActive ? 12 : 11,
                  color: isActive ? Colors.red : Colors.white70,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                child: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navProfile({required int index}) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedScale(
        scale: isActive ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isActive ? 32 : 28,
              width: isActive ? 32 : 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? Colors.red : Colors.white70,
                  width: isActive ? 2 : 1,
                ),
              ),
              child: ClipOval(
                child: Image.asset(Assets.imagesMishIcon, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: isActive ? 12 : 11,
                color: isActive ? Colors.red : Colors.white70,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
