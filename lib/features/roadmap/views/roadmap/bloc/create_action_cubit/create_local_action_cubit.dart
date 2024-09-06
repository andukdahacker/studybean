import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

import '../../../../models/create_local_action_input.dart';

part 'create_local_action_state.dart';

class CreateLocalActionCubit extends Cubit<CreateLocalActionState> {
  CreateLocalActionCubit(this._roadmapLocalRepository) : super(CreateLocalActionInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> createAction(CreateLocalActionInput input) async {
    try {
      emit(CreateLocalActionLoading());
      final action = await _roadmapLocalRepository.createAction(input);
      emit(CreateLocalActionSuccess(action: action));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(CreateLocalActionError());
    }
  }
}
