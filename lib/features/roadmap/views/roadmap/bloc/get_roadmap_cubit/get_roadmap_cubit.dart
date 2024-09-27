import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/get_many_roadmap_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

import '../../../../models/roadmap.dart';

part 'get_roadmap_state.dart';

class GetRoadmapCubit extends Cubit<GetRoadmapState> {
  GetRoadmapCubit(this._roadmapRepository) : super(GetRoadmapInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> getRoadmaps() async {
    emit(GetRoadmapLoading());
    try {
      final response = await _roadmapRepository.getRoadmaps(GetManyRoadmapInput(take: 20));
      emit(GetRoadmapSuccess(response.roadmaps));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(GetRoadmapError());
    }
  }
}