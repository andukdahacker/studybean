import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/roadmap.dart';
import '../../../../repositories/roadmap_local_repository.dart';

part 'get_local_milestone_state.dart';

class GetLocalMilestoneCubit extends Cubit<GetLocalMilestoneState> {
  GetLocalMilestoneCubit(this._roadmapLocalRepository)
      : super(GetLocalMilestoneInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> getMilestone(String id) async {
    try {
      emit(GetLocalMilestoneLoading());

      final milestone = await _roadmapLocalRepository.getMilestoneWithId(id);

      emit(GetLocalMilestoneSuccess(milestone: milestone));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(GetLocalMilestoneError());
    }
  }

  void updateMilestone(Milestone milestone) {
    emit(GetLocalMilestoneSuccess(milestone: milestone));
  }

  void updateMilestoneAction(MilestoneAction action) {
    if (state is! GetLocalMilestoneSuccess) return;
    final successState = state as GetLocalMilestoneSuccess;
    emit(GetLocalMilestoneSuccess(
        milestone: successState.milestone.copyWith(
      actions: successState.milestone.actions
          ?.map((e) => e.id == action.id ? action : e)
          .toList(),
    )));
  }
}
