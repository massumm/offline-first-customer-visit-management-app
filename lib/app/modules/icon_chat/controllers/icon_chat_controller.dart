import 'package:get/get.dart';
import 'package:flutter/material.dart';

class IconChatController extends GetxController {
  // List of chat messages
  final messages = <String>[].obs;

  // Chat input controller
  final textController = TextEditingController();

  // Uncomment below for testing with sample messages
  // final messages = <String>["Hello!", "How are you?", "Welcome to Icon Chat!"].obs;

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      messages.add(text);
      textController.clear();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
