import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/trainee_fitness_report_generation_controller.dart';

class TraineeFitnessReportGenerationView
    extends GetView<TraineeFitnessReportGenerationController> {
  const TraineeFitnessReportGenerationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TraineeFitnessReportGenerationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TraineeFitnessReportGenerationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
