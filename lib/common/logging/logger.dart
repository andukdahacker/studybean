import 'dart:developer';

import 'package:logging/logging.dart';

void setupLogger() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    log(
      record.message,
      time: record.time,
      name: record.loggerName,
      level: record.level.value,
      stackTrace: record.stackTrace,
      error: record.error,
    );
  });
}

final appLogger = Logger('AppLogger');
final httpLogger = Logger('HttpLogger');
