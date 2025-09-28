import 'package:logger/logger.dart';

import '../core/values/app_values.dart';

class EnvConfig {
  final String appName;
  final String productionUrl;
  final String devUrl;
  final String mediaProductionUrl;
  final String mediaDevUrl;

  final String socketDevUrl;
  final String socketProductionUrl;

  final String wsDevUrl;
  final String wsProductionUrl;

  final bool shouldCollectCrashLog;

  late final Logger logger;

  EnvConfig({
    required this.appName,
    required this.productionUrl,
    required this.devUrl,
    required this.mediaProductionUrl,
    required this.mediaDevUrl,
    required this.socketDevUrl,
    required this.socketProductionUrl,
    required this.wsDevUrl,
    required this.wsProductionUrl,

    this.shouldCollectCrashLog = false,
  }) {
    logger = Logger(
      printer: PrettyPrinter(
        /// Number of method calls to be displayed
        methodCount: AppValues.loggerMethodCount,

        /// Number of method calls if stacktrace is provided
        errorMethodCount: AppValues.loggerErrorMethodCount,

        /// width of the output
        lineLength: AppValues.loggerLineLength,

        /// Colorful log messages
        colors: true,

        /// Print an emoji for each log message
        printEmojis: true,

        /// Should each log print contain a timestamp
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
  }
}
