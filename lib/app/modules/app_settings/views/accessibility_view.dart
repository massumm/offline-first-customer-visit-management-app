import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AccessibilityView extends GetView {
  const AccessibilityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AccessibilityView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AccessibilityView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
