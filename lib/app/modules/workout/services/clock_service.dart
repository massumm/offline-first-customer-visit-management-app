import 'dart:async';

import 'package:get/get.dart';

enum ClockMode { timer, stopwatch }

class ClockService extends GetxService {
  final mode = ClockMode.timer.obs;
  final isRunning = false.obs;

  // Timer
  final totalSeconds = 60.obs;
  final remainingSeconds = 60.obs;

  // Stopwatch
  final elapsedSeconds = 0.obs;

  Timer? _ticker;

  /// ---------------- MODE ----------------
  void switchMode(ClockMode newMode) {
    stop();
    mode.value = newMode;
    reset();
  }

  /// ---------------- TIMER ----------------
  void addSeconds(int value) {
    if (mode.value != ClockMode.timer || isRunning.value) return;

    totalSeconds.value = (totalSeconds.value + value).clamp(15, 3600);
    remainingSeconds.value = totalSeconds.value;
  }

  /// ---------------- START / STOP ----------------
  void start() {
    if (isRunning.value) return;
    isRunning.value = true;

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mode.value == ClockMode.timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          stop();
        }
      } else {
        elapsedSeconds.value++;
      }
    });
  }

  void stop() {
    _ticker?.cancel();
    _ticker = null;
    isRunning.value = false;
  }

  void reset() {
    remainingSeconds.value = totalSeconds.value;
    elapsedSeconds.value = 0;
  }

  /// ---------------- DISPLAY ----------------
  String get displayText {
    if (mode.value == ClockMode.timer) {
      final m = remainingSeconds.value ~/ 60;
      final s = remainingSeconds.value % 60;
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    } else {
      final h = elapsedSeconds.value ~/ 3600;
      final m = (elapsedSeconds.value % 3600) ~/ 60;
      final s = elapsedSeconds.value % 60;

      return h > 0
          ? '${h.toString().padLeft(2, '0')}:'
                '${m.toString().padLeft(2, '0')}:'
                '${s.toString().padLeft(2, '0')}'
          : '${m.toString().padLeft(2, '0')}:'
                '${s.toString().padLeft(2, '0')}';
    }
  }

  /// ---------------- PROGRESS ----------------
  double? get progress {
    if (mode.value == ClockMode.timer) {
      // Timer: smooth progress based on remaining seconds
      if (totalSeconds.value == 0) return 0;
      return remainingSeconds.value / totalSeconds.value;
    } else {
      // Stopwatch: progress for the current minute only
      final secondsThisMinute = elapsedSeconds.value % 60;
      return secondsThisMinute / 60;
    }
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
