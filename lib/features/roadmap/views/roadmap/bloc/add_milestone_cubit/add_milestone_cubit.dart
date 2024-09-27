import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/create_milestone_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../../repositories/roadmap_repository.dart';

part 'add_milestone_state.dart';

class AddMilestoneCubit extends Cubit<AddMilestoneState> {
  AddMilestoneCubit(this._roadmapRepository) : super(AddMilestoneInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> createMilestone(CreateMilestoneInput input) async {
    try {
      emit(AddMilestoneLoading());
      final response = await _roadmapRepository.createMilestone(input);
      emit(AddMilestoneSuccess(response));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(AddMilestoneError());
    }
  }
}
