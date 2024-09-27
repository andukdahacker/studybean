import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/create_action_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'create_action_state.dart';

class CreateActionCubit extends Cubit<CreateActionState> {
  CreateActionCubit(this._roadmapRepository) : super(CreateActionInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> createAction(CreateActionInput input) async {
    try {
      emit(CreateActionLoading());
      final action = await _roadmapRepository.createAction(input);
      emit(CreateActionSuccess(action));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(CreateActionError(e));
    }
  }
}
