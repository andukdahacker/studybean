import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'delete_local_action_resource_state.dart';

class DeleteLocalActionResourceCubit extends Cubit<DeleteLocalActionResourceState> {
  DeleteLocalActionResourceCubit(this._roadmapLocalRepository) : super(DeleteLocalActionResourceInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> deleteResource(String resourceId) async {
    try {
      emit(DeleteLocalActionResourceLoading());
      await _roadmapLocalRepository.deleteActionResource(resourceId);
      emit(DeleteLocalActionResourceSuccess(resourceId: resourceId));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteLocalActionResourceError());
    }
  }
}