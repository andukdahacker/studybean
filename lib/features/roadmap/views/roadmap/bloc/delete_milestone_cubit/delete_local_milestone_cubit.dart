import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'delete_local_milestone_state.dart';

class DeleteLocalMilestoneCubit extends Cubit<DeleteLocalMilestoneState> {
  DeleteLocalMilestoneCubit(this._roadmapLocalRepository)
      : super(DeleteLocalMilestoneInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> deleteMilestone(String id) async {
    try {
      emit(DeleteLocalMilestoneLoading());
      await _roadmapLocalRepository.deleteMilestone(id);
      emit(DeleteLocalMilestoneSuccess(milestoneId: id));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteLocalMilestoneError());
    }
  }
}