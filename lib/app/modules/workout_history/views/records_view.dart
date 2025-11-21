import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RecordsViewView extends GetView {
  const RecordsViewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecordsViewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RecordsViewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
