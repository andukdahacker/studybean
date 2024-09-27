import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'delete_milestone_state.dart';

class DeleteMilestoneCubit extends Cubit<DeleteMilestoneState> {
  DeleteMilestoneCubit(this._roadmapRepository) : super(DeleteMilestoneInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> deleteMilestone(String id) async {
    try {
      emit(DeleteMilestoneLoading());
      await _roadmapRepository.deleteMilestone(id);
      emit(DeleteMilestoneSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteMilestoneError());
    }
  }
}