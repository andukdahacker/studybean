import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'resource_state.dart';

class ResourceCubit extends Cubit<ResourceState> {
  ResourceCubit(this._roadmapRepository) : super(ResourceInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> getFile(String url, String resourceId) async {
    try {
      emit(ResourceLoading());

      final resourceUrlFilePath = await _roadmapRepository.downloadFile(url, resourceId);

      emit(ResourceLoaded(filePath: resourceUrlFilePath));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(ResourceFailed(e));
    }
  }
}