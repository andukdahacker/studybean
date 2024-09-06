import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:studybean/common/logging/app_bloc_observer.dart';
import 'package:studybean/common/logging/logger.dart';

import 'common/di/get_it.dart';

class AppConfig {
  Future<void> initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await initGetIt();
    setupLogger();
    setupAppBlocObserver();
  }
}