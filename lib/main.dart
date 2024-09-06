import 'package:flutter/material.dart';
import 'package:studybean/app_config.dart';

import 'app.dart';

Future<void> main() async {
  await AppConfig().initApp();
  runApp(const MyApp());
}
