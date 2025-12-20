import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:vibration/vibration.dart';

class TimedProgressBar extends StatefulWidget {
  final int seconds;
  final bool hideOnComplete;

  const TimedProgressBar({
    super.key,
    required this.seconds,
    this.hideOnComplete = false,
  });

  @override
  State<TimedProgressBar> createState() => _TimedProgressBarState();
}

class _TimedProgressBarState extends State<TimedProgressBar> {
  late ValueNotifier<int> _remainingSeconds;
  Timer? _timer;
  bool _hasVibrated = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = ValueNotifier<int>(widget.seconds);
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant TimedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _timer?.cancel();
      _hasVibrated = false;
      _remainingSeconds.value = widget.seconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds.value <= 1) {
        timer.cancel();
        _remainingSeconds.value = 0;
        if (!_hasVibrated) {
          _hasVibrated = true;
          if (await (Vibration.hasVibrator())) {
            Vibration.vibrate(duration: 210);
          }
        }
      } else {
        _remainingSeconds.value--;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remainingSeconds.dispose();
    super.dispose();
  }

  double _progress(int remaining) =>
      (remaining / widget.seconds).clamp(0.0, 1.0);

  String _formattedTime(int remaining) {
    final m = remaining ~/ 60;
    final s = remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const double height = 18;
    final double radius = height / 2;

    return ValueListenableBuilder<int>(
      valueListenable: _remainingSeconds,
      builder: (context, remaining, child) {
        if (widget.hideOnComplete && remaining == 0) {
          return const SizedBox.shrink();
        }

        if (remaining <= 0) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              6.width,
              Text(
                _formattedTime(widget.seconds),
                style: TextStyle(
                  color: AppColors.activityPrimaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              6.width,
              Divider(),
            ],
          );
        }

        double progress = _progress(remaining);
        String time = _formattedTime(remaining);

        final Color timerTextColor = progress >= 0.5
            ? Colors.white
            : const Color(0xFF241814);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Unfilled bar
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBE5),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
                // Filled bar
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: height,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF241814), Color(0xFFC31212)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: timerTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
