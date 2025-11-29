import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ActiveSessionsView extends GetView {
  const ActiveSessionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActiveSessionsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActiveSessionsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
