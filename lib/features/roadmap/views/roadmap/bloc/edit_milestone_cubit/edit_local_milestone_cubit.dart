import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/edit_local_milestone_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'edit_local_milestone_state.dart';

class EditLocalMilestoneCubit extends Cubit<EditLocalMilestoneState> {
  EditLocalMilestoneCubit(this._roadmapLocalRepository) : super(EditLocalMilestoneInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> editMilestone(EditLocalMilestoneInput input) async {
    try {
      emit(EditLocalMilestoneLoading());
      final roadmap = await _roadmapLocalRepository.updateMilestone(input);
      emit(EditLocalMilestoneSuccess(roadmap));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(EditLocalMilestoneError());
    }
  }
}