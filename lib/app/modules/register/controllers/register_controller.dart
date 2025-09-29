import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  var obscurePassword = true.obs;
  var rememberMe = false.obs;

  // TextInput validation error
  var passwordError = RxnString();
  var emailError = RxnString();
  var isLoading = false.obs;
}
