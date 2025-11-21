import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChartsViewView extends GetView {
  const ChartsViewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChartsViewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChartsViewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
