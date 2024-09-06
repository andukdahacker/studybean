import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/edit_local_action_resource_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';

import '../../../../models/roadmap.dart';

part 'edit_local_action_resource_state.dart';

class EditLocalActionResourceCubit extends Cubit<EditLocalActionResourceState> {
  EditLocalActionResourceCubit(this._roadmapLocalRepository)
      : super(EditLocalActionResourceInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> editLocalActionResource(
      EditLocalActionResourceInput input) async {
    try {
      emit(EditLocalActionResourceLoading());
      final resource = await _roadmapLocalRepository.editActionResource(input);
      emit(EditLocalActionResourceSuccess(resource: resource));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(EditLocalActionResourceError());
    }
  }
}
