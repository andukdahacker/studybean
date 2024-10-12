import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/auth/repository/auth_local_repository.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';
import 'package:studybean/features/roadmap/repositories/user_local_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._roadmapLocalRepository, this._userLocalRepository,
      this._authLocalRepository)
      : super(SplashInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;
  final UserLocalRepository _userLocalRepository;
  final AuthLocalRepository _authLocalRepository;

  Future<void> init() async {
    try {
      await Future.delayed(const Duration(milliseconds: 2000));
      final authUser = await _authLocalRepository.getUser();
      if (authUser != null) {
        emit(SplashLoaded());
        return;
      }

      final localRoadmaps = await _roadmapLocalRepository.getRoadmaps();
      final isFirstTime = localRoadmaps.isEmpty;

      if (isFirstTime) {
        final localUser = await _userLocalRepository.getUser();
        if (localUser == null) {
          await _userLocalRepository.createUser();
        }
        await _userLocalRepository.refreshCredits(localUser?.id ?? '');
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
