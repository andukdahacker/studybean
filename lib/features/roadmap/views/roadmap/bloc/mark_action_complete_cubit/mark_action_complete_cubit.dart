import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/models/update_action_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'mark_action_complete_state.dart';

class MarkActionCompleteCubit extends Cubit<MarkActionCompleteState> {
  MarkActionCompleteCubit(this._roadmapRepository)
      : super(MarkActionCompleteInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> updateActionComplete(String actionId, bool isCompleted) async {
    try {
      emit(MarkActionCompleteLoading());

      final action = await _roadmapRepository.updateAction(
          UpdateActionInput(id: actionId, isCompleted: isCompleted));

      emit(MarkActionCompleteSuccess(action));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(MarkActionCompleteFailure());
    }
  }
}
