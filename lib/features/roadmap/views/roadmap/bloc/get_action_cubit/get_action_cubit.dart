import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'get_action_state.dart';

class GetActionCubit extends Cubit<GetActionState> {
  GetActionCubit(this._roadmapRepository) : super(GetActionInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> getAction(String actionId) async {
    try {
      emit(GetActionLoading());
      final action = await _roadmapRepository.getAction(actionId);
      emit(GetActionSuccess(action));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(GetActionError(e));
    }
  }

  void updateAction(MilestoneAction action) {
    emit(GetActionSuccess(action));
  }

  void addActionResource(ActionResource resource) {
    if(state is! GetActionSuccess) return;
    final successState = state as GetActionSuccess;
    emit(GetActionSuccess(
      successState.action.copyWith(resource: [...?successState.action.resource, resource]),
    ));
  }

  void removeActionResource(String id) {
    if(state is! GetActionSuccess) return;
    final successState = state as GetActionSuccess;
    emit(GetActionSuccess(
      successState.action.copyWith(resource: successState.action.resource?.where((element) => element.id != id).toList()),
    ));
  }

  void updateActionResource(ActionResource resource) {
    if(state is! GetActionSuccess) return;
    final successState = state as GetActionSuccess;
    emit(GetActionSuccess(
      successState.action.copyWith(resource: successState.action.resource?.map((e) => e.id == resource.id ? resource : e).toList()),
    ));
  }
}
