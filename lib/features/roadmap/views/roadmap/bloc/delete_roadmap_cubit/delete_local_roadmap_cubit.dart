import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'delete_local_roadmap_state.dart';

class DeleteLocalRoadmapCubit extends Cubit<DeleteLocalRoadmapState> {
  DeleteLocalRoadmapCubit(this._roadmapLocalRepository): super(DeleteLocalRoadmapInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> deleteRoadmap() async {
    try {
      await _roadmapLocalRepository.deleteAllRoadmap();
      emit(DeleteLocalRoadmapSuccess());
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteLocalRoadmapError(e));
    }
  }
}