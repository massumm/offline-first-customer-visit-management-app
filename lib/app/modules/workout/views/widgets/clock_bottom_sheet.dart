import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../services/clock_service.dart';

void showClockBottomSheet(BuildContext context) {
  final controller = Get.put(ClockService(), tag: UniqueKey().toString());
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // backgroundColor: bgColor,
    elevation: 0,
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Clock', style: theme.textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.delete<ClockService>();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Mode Switch
              Row(
                children: [
                  _modeButton(theme, controller, 'Timer', ClockMode.timer),
                  const SizedBox(width: 8),
                  _modeButton(
                    theme,
                    controller,
                    'Stopwatch',
                    ClockMode.stopwatch,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// BIG PROGRESS DIAL
              SizedBox(
                height: 240,
                width: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: CircularProgressIndicator(
                        value: controller.progress,
                        strokeWidth: 14,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.activityPrimaryColor,
                        ),
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      controller.displayText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// TIMER CONTROLS
              if (controller.mode.value == ClockMode.timer)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _circleButton(
                      theme,
                      '-15s',
                      () => controller.addSeconds(-15),
                    ),
                    _circleButton(
                      theme,
                      '+15s',
                      () => controller.addSeconds(15),
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              /// START / STOP
              Row(
                children: [
                  // Start / Stop button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isRunning.value
                          ? controller.stop
                          : controller.start,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                      ),
                      child: Text(
                        controller.isRunning.value ? 'Stop' : 'Start',
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Reset button
                  if (controller.isRunning.value)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondaryContainer,
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// ================= UI HELPERS =================
Widget _modeButton(
  ThemeData theme,
  ClockService controller,
  String label,
  ClockMode mode,
) {
  final active = controller.mode.value == mode;

  return Expanded(
    child: GestureDetector(
      onTap: () => controller.switchMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: active ? Colors.transparent : theme.scaffoldBackgroundColor,
          border: Border.all(
            color: active ? AppColors.activityPrimaryColor : Colors.transparent,
          ),
        ),
        child: Center(child: Text(label, style: theme.textTheme.titleSmall!.copyWith(
          color: active ? theme.colorScheme.secondaryContainer : theme.colorScheme.onSecondaryContainer,
        ))),
      ),
    ),
  );
}

Widget _circleButton(ThemeData theme, String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: Get.isDarkMode
          ? theme.scaffoldBackgroundColor
          : AppColors.colorPrimary.withValues(alpha: 0.25),

      radius: 30,
      child: Text(
        text,
        style: theme.textTheme.titleSmall!.copyWith(
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}
