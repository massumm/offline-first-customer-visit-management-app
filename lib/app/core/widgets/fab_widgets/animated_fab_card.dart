import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedFabCard extends StatelessWidget {
  final RxDouble height;
  final RxDouble cardContainerHeight;
  final List<Widget> fabCards;
  const AnimatedFabCard({
    super.key,
    required this.height,
    required this.cardContainerHeight,
    required this.fabCards,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 90),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(color: Colors.black87.withAlpha(90)),
          height: height.value,
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: .end,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 90),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: cardContainerHeight.value,
                  width: Get.width * 0.9,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: fabCards,
                    ),
                  ),
                ),
                SizedBox(height: 90),
              ],
            ),
          ),
        ),
      );
    });
  }
}
