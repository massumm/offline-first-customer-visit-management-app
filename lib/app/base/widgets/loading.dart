import 'package:flutter/material.dart';

import '../../core/values/app_values.dart';
import 'elevated_container.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedContainer(
        padding: const EdgeInsets.all(AppValues.margin),
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
