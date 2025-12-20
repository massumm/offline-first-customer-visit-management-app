
import 'package:get/get.dart';
import 'package:icon/app/modules/start_workout/controllers/start_workout_controller.dart';

class RestTimerService extends GetxService {


  final RxInt selectedMinute = 0.obs;
  final RxInt selectedSecond = 0.obs;
  StartWorkoutController? _controller;

  final RxInt totalRestTimeInSec = 0.obs;

  void attach(StartWorkoutController controller){
    _controller = controller;
  }

 void detach(){
    _controller = null;
  }

  String get readableRestTime {
    final minutes = (totalRestTimeInSec.value ~/ 60).toString();
    final seconds = (totalRestTimeInSec.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

}