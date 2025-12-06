import 'package:get/get.dart';

import '../controllers/your_activity_goals_controller.dart';

class YourActivityGoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourActivityGoalsController>(
      () => YourActivityGoalsController(),
    );
  }
}
