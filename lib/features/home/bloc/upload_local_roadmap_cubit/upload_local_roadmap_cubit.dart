import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'upload_local_roadmap_state.dart';

class UploadLocalRoadmapCubit extends Cubit<UploadLocalRoadmapState> {
  UploadLocalRoadmapCubit(this._roadmapRepository, this._roadmapLocalRepository)
      : super(UploadLocalRoadmapInitial());

  final RoadmapRepository _roadmapRepository;
  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> uploadLocalRoadmap() async {
    try {
      final localRoadmaps = await _roadmapLocalRepository.getRoadmaps();

      if (localRoadmaps.isEmpty) {
        return;
      }

      emit(UploadLocalRoadmapLoading());
      await _roadmapRepository.uploadLocalRoadmaps(localRoadmaps);
      await _roadmapLocalRepository.deleteAllRoadmap();
      emit(UploadLocalRoadmapSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(UploadLocalRoadmapError(error: e));
    }
  }
}
