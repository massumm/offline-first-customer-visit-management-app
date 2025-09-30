import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

class HomeController extends BaseController {
  // .............. Dummy data ................
  final username = 'Mish';

  // Example week data (Mon–Sun)
  final week = <DayItem>[
    DayItem('Mon', 21, 0.85, false),
    DayItem('Tue', 22, 0.25, false),
    DayItem('Wed', 23, 0.70, false),
    DayItem('Thu', 24, 0.60, false),
    DayItem('Fri', 25, 0.10, true), // current day
    DayItem('Sat', 26, 0.0, false),
    DayItem('Sun', 27, 0.0, false),
  ];
}


class DayItem {
  final String label; // Mon/Tue...
  final int date;     // 21/22...
  final double progress; // 0..1
  final bool isToday;

  DayItem(this.label, this.date, this.progress, this.isToday);
}