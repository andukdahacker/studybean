import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'delete_local_action_state.dart';

class DeleteLocalActionCubit extends Cubit<DeleteLocalActionState> {
  DeleteLocalActionCubit(this._roadmapLocalRepository)
      : super(DeleteLocalActionInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> deleteAction(String actionId) async {
    try {
      emit(DeleteLocalActionLoading());
      await _roadmapLocalRepository.deleteAction(actionId);
      emit(DeleteLocalActionSuccess(actionId: actionId));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteLocalActionError());
    }
  }
}