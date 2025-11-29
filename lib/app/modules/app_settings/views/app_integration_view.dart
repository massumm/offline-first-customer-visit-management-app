import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AppIntegrationView extends GetView {
  const AppIntegrationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppIntegrationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AppIntegrationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
