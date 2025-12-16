import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon/app/core/widgets/bottom_sheet/base_bottom_sheet.dart';

class RecoveryLogMenu extends StatelessWidget {
  const RecoveryLogMenu({super.key});

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
