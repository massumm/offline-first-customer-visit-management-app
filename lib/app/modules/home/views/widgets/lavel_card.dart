import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/progress_bar/gradient_circular_progress_bar.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/generated/assets.dart';

class LevelCard extends StatelessWidget {
  final String label;
  final double percent;
  final List<Color> gradientColors;
  final TextStyle? style;

  const LevelCard({
    super.key,
    required this.label,
    this.percent = 0.8,
    this.gradientColors = const [
      Color(0xffFFE2DA),
      Color(0xffF7B858),
      Color(0xffE9522B),
    ],
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE1E3E9)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'For next level',
                style: TextStyle(
                  color: const Color(0xFF241814),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.close)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleGradientStackCircularProgressBar(
                size: 140,
                barValue: 75,
                barColores: gradientColors,
                progressStrokeWidth: 12,
                backStrokeWidth: 12,
                backColor: Color(0XFFFFF3F0),
                fullProgressColor: Colors.black,
                mergeMode: true,
                isTextShow: true,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                animationDuration: const Duration(seconds: 4),
              ),

              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DiamondListRow(),
                  Divider(
                    color: const Color(0xFFE1E3E9),
                    thickness: 1,
                    height: 16,
                  ),
                  Row(
                    children: [
                      SuperImage(Assets.svgCheckmark, height: 16, width: 16),
                      8.width,
                      Text(
                        '7-Day Workout Streak',
                        style: TextStyle(
                          color: const Color(
                            0xFF241814,
                          ) /* User-Light-Typography-Primary */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SuperImage(Assets.svgCheckmark, height: 16, width: 16),
                      8.width,
                      Text(
                        '5K Personal Record',
                        style: TextStyle(
                          color: const Color(0xFF241814),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12,)
        ],
      ),
    );
  }
}

class DiamondListRow extends StatelessWidget {
  final int count;

  const DiamondListRow({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Transform.rotate(
            angle: 45 * 3.14159 / 180, // 45° rotation
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0XFFFFF3F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.star,
                  color: AppColors.colorPrimarySwatch.shade400,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
