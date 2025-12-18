import 'package:flutter/material.dart';

import '../super_widgets/super_icon.dart';
import '../super_widgets/super_icon_source.dart';

class FabCardItem extends StatelessWidget {
  final String title;
  final SuperIconSource source;
  const FabCardItem({super.key, required this.title, required this.source});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Color(0x1AE8FBEC),
              maxRadius: 30,
              child: SuperIcon(source: source),
            ),
            SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
