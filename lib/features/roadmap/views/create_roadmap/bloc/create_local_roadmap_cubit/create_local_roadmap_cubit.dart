import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

import '../../../../models/create_local_roadmap_input.dart';
import '../../../../models/roadmap.dart';

part 'create_local_roadmap_state.dart';

class CreateLocalRoadmapCubit extends Cubit<CreateLocalRoadmapState> {
  CreateLocalRoadmapCubit(this._roadmapLocalRepository)
      : super(CreateLocalRoadmapInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> createLocalRoadmap(CreateLocalRoadmapInput input, bool isFirstTime) async {
    try {
      emit(CreateLocalRoadmapLoading());
      if(!isFirstTime) {
        await _roadmapLocalRepository.deleteAllRoadmap();
      }

      final roadmap = await _roadmapLocalRepository.createRoadmap(
        input
      );

      emit(CreateLocalRoadmapSuccess(roadmap));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(CreateLocalRoadmapError());
    }
  }
}
