import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/edit_milestone_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

import '../../../../models/roadmap.dart';

part 'edit_milestone_state.dart';

class EditMilestoneCubit extends Cubit<EditMilestoneState> {
  EditMilestoneCubit(this._roadmapRepository) : super(EditMilestoneInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> editMilestone(EditMilestoneInput input) async {
    try {
      emit(EditMilestoneLoading());
      final milestone = await _roadmapRepository.updateMilestone(input);
      emit(EditMilestoneSuccess(milestone: milestone));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(EditMilestoneError(error: e));
    }
  }
}
