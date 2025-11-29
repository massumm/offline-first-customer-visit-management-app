import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DeleteAccountView extends GetView {
  const DeleteAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeleteAccountView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DeleteAccountView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
