import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';

import '../controllers/fitness_report_controller.dart';

class ReportGeneratingView extends BaseView<FitnessReportController> {
  ReportGeneratingView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generating Report')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Generating your fitness report...'),
          ],
        ),
      ),
    );
  }
}
