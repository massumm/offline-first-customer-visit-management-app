import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/generated/assets.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key, required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            height: 80,
            width: 80,
            child: Image.asset(
              Assets.imagesFitnessReportFace,
              height: 100,
              width: 100,
            ),
          ),
        ),
        16.height,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            body,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
