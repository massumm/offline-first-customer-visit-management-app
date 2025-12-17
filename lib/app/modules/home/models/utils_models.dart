import 'dart:ui';

import 'package:flutter/material.dart';

class DayItem {
  final String label; // Mon/Tue...
  final int date; // 21/22...
  final double progress; // 0..1
  final bool isToday;

  DayItem(this.label, this.date, this.progress, this.isToday);
}

class ActionCardData {
  final String title;
  final Color color;
  final double percent;
  final LinearGradient? gradient;

  ActionCardData({
    required this.title,
    required this.color,
    required this.percent,
    this.gradient,
  });
}