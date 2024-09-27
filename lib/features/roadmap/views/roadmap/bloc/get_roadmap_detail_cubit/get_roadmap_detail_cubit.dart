import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/roadmap.dart';
import '../../../../repositories/roadmap_repository.dart';

part 'get_roadmap_detail_state.dart';

class GetRoadmapDetailCubit extends Cubit<GetRoadmapDetailState> {
  GetRoadmapDetailCubit(this._roadmapRepository)
      : super(GetRoadmapDetailInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> getRoadmapDetail(String id) async {
    try {
      emit(GetRoadmapDetailLoading());
      final response = await _roadmapRepository.getRoadmapById(id);
      emit(GetRoadmapDetailSuccess(response));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(GetRoadmapDetailError());
    }
  }
}