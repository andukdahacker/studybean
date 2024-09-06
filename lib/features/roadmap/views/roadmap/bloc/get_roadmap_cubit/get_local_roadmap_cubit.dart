import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

import '../../../../models/roadmap.dart';

part 'get_local_roadmap_state.dart';

class GetLocalRoadmapCubit extends Cubit<GetLocalRoadmapState> {
  GetLocalRoadmapCubit(this._roadmapLocalRepository) : super(GetLocalRoadmapInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> getRoadmaps() async {
    try {
      emit(GetLocalRoadmapLoading());
      final roadmaps = await _roadmapLocalRepository.getRoadmaps();

      emit(GetLocalRoadmapSuccess(roadmaps));
    } catch (e,stackTrace) {
      addError(e, stackTrace);
      emit(GetLocalRoadmapError());
    }
  }
}