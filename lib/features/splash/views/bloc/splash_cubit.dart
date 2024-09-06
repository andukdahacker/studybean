import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/services/shared_preference_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._sharedPreferenceService) : super(SplashInitial());

  final SharedPreferenceService _sharedPreferenceService;

  Future<void> init() async {
    try {
      await Future.delayed(const Duration(milliseconds: 2000));
      final isFirstTime = _sharedPreferenceService.checkIfFirstTime();

      if (isFirstTime) {
        await _sharedPreferenceService.setFirstTime();
        emit(SplashFirstTime());
      } else {
        emit(SplashLoaded());
      }

    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SplashError(e));
    }
  }
}