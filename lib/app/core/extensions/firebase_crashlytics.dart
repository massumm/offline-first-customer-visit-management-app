import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

extension CrashlyticsLogging on Object {
  Future<void> logToCrashlytics(StackTrace stack, {String? reason, bool fatal = false}) async {
    if(kReleaseMode){
      await FirebaseCrashlytics.instance.recordError(
        this,
        stack,
        reason: reason,
        fatal: fatal,
      );
    }
  }
}
