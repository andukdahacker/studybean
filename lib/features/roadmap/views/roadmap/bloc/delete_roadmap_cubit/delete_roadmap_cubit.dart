import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'delete_roadmap_state.dart';

class DeleteRoadmapCubit extends Cubit<DeleteRoadmapState> {
  DeleteRoadmapCubit(this._roadmapRepository) : super(DeleteRoadmapInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> deleteRoadmap(String id) async {
    try {
      emit(DeleteRoadmapLoading());
      await _roadmapRepository.deleteRoadmap(id);
      emit(DeleteRoadmapSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteRoadmapError(error: e));
    }
  }
}