import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/create_milestone_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

import '../../../../models/roadmap.dart';

part 'add_local_milestone_state.dart';

class AddLocalMilestoneCubit extends Cubit<AddLocalMilestoneState> {
  AddLocalMilestoneCubit(this._roadmapLocalRepository)
      : super(AddLocalMilestoneInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> createMilestone(CreateMilestoneInput input) async {
    try {
      emit(AddLocalMilestoneLoading());

      final milestone = await _roadmapLocalRepository.createMilestone(input);

      emit(AddLocalMilestoneSuccess(milestone: milestone));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(AddLocalMilestoneError());
    }
  }
}
