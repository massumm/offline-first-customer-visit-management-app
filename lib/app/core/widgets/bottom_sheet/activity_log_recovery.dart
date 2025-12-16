import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../base/widgets/base_bottom_sheet.dart';
import 'base_bottom_sheet.dart';

class Activity_RecoveryLogMenu extends StatelessWidget {
  const Activity_RecoveryLogMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet_Tracker(
      title: 'Recovery Logs',
      child: const Text(
        'View your recovery history here',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
