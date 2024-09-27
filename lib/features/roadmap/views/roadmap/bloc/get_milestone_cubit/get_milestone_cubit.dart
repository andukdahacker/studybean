import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'get_milestone_state.dart';

class GetMilestoneCubit extends Cubit<GetMilestoneState> {
  GetMilestoneCubit(this._roadmapRepository) : super(GetMilestoneInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> getMilestone(String id) async {
    try {
      emit(GetMilestoneLoading());
      final response = await _roadmapRepository.getMilestoneById(id);
      emit(GetMilestoneSuccess(milestone: response));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(GetMilestoneError());
    }
  }

  void updateMilestone(Milestone milestone) {
    emit(GetMilestoneSuccess(milestone: milestone));
  }

  void updateMilestoneAction(MilestoneAction action) {
    if (state is! GetMilestoneSuccess) return;
    final successState = state as GetMilestoneSuccess;
    emit(GetMilestoneSuccess(
        milestone: successState.milestone.copyWith(
          actions: successState.milestone.actions
              ?.map((e) => e.id == action.id ? action : e)
              .toList(),
        )));
  }
}