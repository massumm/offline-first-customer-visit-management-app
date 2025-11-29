import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HelpAndSupportView extends GetView {
  const HelpAndSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HelpAndSupportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HelpAndSupportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
