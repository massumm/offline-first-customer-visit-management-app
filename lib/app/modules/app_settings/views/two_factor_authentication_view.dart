import 'package:flutter/material.dart';

import 'package:get/get.dart';

class TwoFactorAuthenticationView extends GetView {
  const TwoFactorAuthenticationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TwoFactorAuthenticationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TwoFactorAuthenticationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
