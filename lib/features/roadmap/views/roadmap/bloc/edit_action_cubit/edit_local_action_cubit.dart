import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/edit_local_action_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

import '../../../../models/roadmap.dart';

part 'edit_local_action_state.dart';

class EditLocalActionCubit extends Cubit<EditLocalActionState> {
  EditLocalActionCubit(this._roadmapLocalRepository)
      : super(EditLocalActionInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> editAction(EditLocalActionInput input) async {
    try {
      emit(EditLocalActionLoading());
      final action = await _roadmapLocalRepository.editAction(input);
      emit(EditLocalActionSuccess(action: action));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
    }
  }

}