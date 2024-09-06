import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'mark_local_action_complete_state.dart';

class MarkLocalActionCompleteCubit extends Cubit<MarkLocalActionCompleteState> {
  MarkLocalActionCompleteCubit(this._roadmapLocalRepository)
      : super(MarkLocalActionCompleteInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> updateActionComplete(String actionId, bool isCompleted) async {
    try {
      emit(MarkLocalActionCompleteLoading());
      final action = await _roadmapLocalRepository.updateActionComplete(
          actionId, isCompleted);
      emit(MarkLocalActionCompleteSuccess(action: action));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(MarkLocalActionCompleteFailure());
    }
  }
}
