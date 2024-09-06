import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/logging/logger.dart';

void setupAppBlocObserver() {
  Bloc.observer = AppBlocObserver();
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    appLogger.info('Changed: ${bloc.runtimeType}, $change');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    appLogger.info('Created: ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    appLogger.info('Closed: ${bloc.runtimeType}');
  }
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    appLogger.info('Error: ${bloc.runtimeType}, $error', stackTrace);
  }
}