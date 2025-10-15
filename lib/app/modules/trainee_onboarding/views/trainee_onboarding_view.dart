import 'package:flutter/material.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/widgets/input_widgets/adaptive_text_field.dart';

import '../../icon_chat/views/icon_chat_view.dart';
import '../controllers/trainee_onboarding_controller.dart';

class TraineeOnboardingView extends BaseView<TraineeOnboardingController> {
  TraineeOnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: CustomAppBar(),
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
        right: 8
      ),
      child: Row(
        children: [
          Expanded(
            child: AdaptiveSuperTextField(
              controller: controller.messageTextCtr,
              hintText: 'Type Here...',
              onChanged: (value) {},
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.send)),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return const Center(
      child: Text(
        'TraineeOnboardingView is working',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
