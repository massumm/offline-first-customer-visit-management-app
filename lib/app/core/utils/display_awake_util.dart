import 'package:wakelock_plus/wakelock_plus.dart';

class DisplayAwakeUtil {
  static Future<void> setAwake(bool enable) async {
    if (enable) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  }
}
