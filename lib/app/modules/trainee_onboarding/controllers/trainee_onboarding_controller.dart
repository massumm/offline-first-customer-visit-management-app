import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

class TraineeOnboardingController extends BaseController {
  final TextEditingController messageTextCtr = TextEditingController();

  @override
  void onClose() {
    messageTextCtr.clear();
    super.onClose();
  }
}
