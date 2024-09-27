import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../../models/update_action_input.dart';
import '../../../../repositories/roadmap_repository.dart';

part 'edit_action_state.dart';

class EditActionCubit extends Cubit<EditActionState> {
  EditActionCubit(this._roadmapRepository) : super(EditActionInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> editAction(UpdateActionInput input) async {
    try {
      emit(EditActionLoading());
      final action = await _roadmapRepository.updateAction(input);
      emit(EditActionSuccess(action));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(EditActionError(e));
    }
  }
}