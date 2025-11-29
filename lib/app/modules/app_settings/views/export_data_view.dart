import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ExportDataView extends GetView {
  const ExportDataView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExportDataView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExportDataView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
