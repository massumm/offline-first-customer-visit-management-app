import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UnitsAndPreferrencesView extends GetView {
  const UnitsAndPreferrencesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UnitsAndPreferrencesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UnitsAndPreferrencesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
