import 'package:flutter/material.dart';

class OnboardingItem {
  final Widget imageWidget;
  final String title;
  final String description;
  final String buttonLabel;

  OnboardingItem({
    required this.imageWidget,
    required this.title,
    required this.description,
    required this.buttonLabel,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageWidget': imageWidget,
      'title': title,
      'description': description,
      'buttonLabel': buttonLabel,
    };
  }
}
