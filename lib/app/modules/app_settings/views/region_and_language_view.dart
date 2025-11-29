import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RegionAndLanguageView extends GetView {
  const RegionAndLanguageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegionAndLanguageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RegionAndLanguageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
