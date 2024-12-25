import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/services/shared_preference_service.dart';
import 'package:studybean/features/auth/repository/auth_local_repository.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._roadmapLocalRepository,
    this._authLocalRepository,
    this._sharedPreferenceService,
  ) : super(SplashInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;
  final SharedPreferenceService _sharedPreferenceService;
  final AuthLocalRepository _authLocalRepository;

  Future<void> init() async {
    try {
      // await Future.delayed(const Duration(milliseconds: 2000));
      final authUser = await _authLocalRepository.getUser();
      if (authUser != null) {
        emit(SplashLoaded());
        return;
      }

      final localRoadmaps = await _roadmapLocalRepository.getRoadmaps();
      final isFirstTime = localRoadmaps.isEmpty;

      if (isFirstTime) {
        await _sharedPreferenceService.resetCredits();
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
