
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/clock_service.dart';

void showClockBottomSheet(BuildContext context) {
  final controller = Get.put(ClockService(), tag: UniqueKey().toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  const Text('Clock', style: TextStyle(fontSize: 18)),
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
                  _modeButton(controller, 'Timer', ClockMode.timer),
                  const SizedBox(width: 8),
                  _modeButton(controller, 'Stopwatch', ClockMode.stopwatch),
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
                    _circleButton('-15s', () => controller.addSeconds(-15)),
                    _circleButton('+15s', () => controller.addSeconds(15)),
                  ],
                ),

              const SizedBox(height: 24),

              /// START / STOP
              /// ---------------- START / STOP + RESET ----------------
              Row(
                children: [
                  // Start / Stop button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isRunning.value
                          ? controller.stop
                          : controller.start,
                      child: Text(
                        controller.isRunning.value ? 'Stop' : 'Start',
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Reset button (only visible when running)
                  if (controller.isRunning.value)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey, // optional: different color
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
Widget _modeButton(ClockService controller, String label, ClockMode mode) {
  final active = controller.mode.value == mode;

  return Expanded(
    child: GestureDetector(
      onTap: () => controller.switchMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: active ? Colors.red.shade100 : Colors.grey.shade300,
        ),
        child: Center(child: Text(label)),
      ),
    ),
  );
}

Widget _circleButton(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(radius: 30, child: Text(text)),
  );
}
