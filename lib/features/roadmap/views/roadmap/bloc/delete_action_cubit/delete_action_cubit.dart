import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'delete_action_state.dart';

class DeleteActionCubit extends Cubit<DeleteActionState> {
  DeleteActionCubit(this._roadmapRepository) : super(DeleteActionInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> deleteAction(String id) async {
    try {
      emit(DeleteActionLoading());
      await _roadmapRepository.deleteAction(id);
      emit(DeleteActionSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteActionError(e));
    }
  }
}
