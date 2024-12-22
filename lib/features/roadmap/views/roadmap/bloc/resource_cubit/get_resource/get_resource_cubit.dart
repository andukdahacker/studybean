import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'get_resource_state.dart';

class GetResourceCubit extends Cubit<GetResourceState> {
  GetResourceCubit(this._roadmapRepository) : super(GetResourceInitial());

  final RoadmapRepository _roadmapRepository;

  void reloadResource(ActionResource actionResource) {
    emit(GetResourceSuccess(actionResource));
  }

  Future<void> getResource(String resourceId) async {
    try {
      emit(GetResourceLoading());

      final response = await _roadmapRepository.getResource(resourceId);

      emit(GetResourceSuccess(response));
    } catch(e, stackTrace) {
      addError(e,stackTrace);
      emit(GetResourceFailed(e));
    }
  }
}