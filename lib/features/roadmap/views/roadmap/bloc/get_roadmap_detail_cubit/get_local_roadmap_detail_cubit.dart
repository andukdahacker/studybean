import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/roadmap.dart';
import '../../../../repositories/roadmap_local_repository.dart';

part 'get_local_roadmap_detail_state.dart';

class GetLocalRoadmapDetailCubit extends Cubit<GetLocalRoadmapDetailState> {
  GetLocalRoadmapDetailCubit(this._roadmapLocalRepository)
      : super(GetLocalRoadmapDetailInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> getRoadmapDetail(String id) async {
    try {
      emit(GetLocalRoadmapDetailLoading());
      final roadmap = await _roadmapLocalRepository.getRoadmapWithId(id);

      emit(GetLocalRoadmapDetailSuccess(roadmap));
    } catch (e,stackTrace) {
      addError(e, stackTrace);
      emit(GetLocalRoadmapDetailError());
    }
  }
}