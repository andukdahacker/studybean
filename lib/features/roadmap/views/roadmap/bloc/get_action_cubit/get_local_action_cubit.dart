import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

part 'get_local_action_state.dart';

class GetLocalActionCubit extends Cubit<GetLocalActionState> {
  GetLocalActionCubit(this._roadmapLocalRepository)
      : super(GetLocalActionInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> getAction(String actionId) async {
    try {
      emit(GetLocalActionLoading());
      final action = await _roadmapLocalRepository.getActionWithId(actionId);
      emit(GetLocalActionSuccess(action: action));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(GetLocalActionError());
    }
  }

  void updateAction(MilestoneAction action) {
    emit(GetLocalActionSuccess(action: action));
  }

  void addActionResource(ActionResource resource) {
    if(state is! GetLocalActionSuccess) return;
    final successState = state as GetLocalActionSuccess;
    emit(GetLocalActionSuccess(
      action: successState.action.copyWith(resource: [...?successState.action.resource, resource]),
    ));
  }

  void removeActionResource(String id) {
    if(state is! GetLocalActionSuccess) return;
    final successState = state as GetLocalActionSuccess;
    emit(GetLocalActionSuccess(
      action: successState.action.copyWith(resource: successState.action.resource?.where((element) => element.id != id).toList()),
    ));
  }

  void updateActionResource(ActionResource resource) {
    if(state is! GetLocalActionSuccess) return;
    final successState = state as GetLocalActionSuccess;
    emit(GetLocalActionSuccess(
      action: successState.action.copyWith(resource: successState.action.resource?.map((e) => e.id == resource.id ? resource : e).toList()),
    ));
  }

}
