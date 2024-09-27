import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/edit_action_resource_input.dart';
import '../../../../models/roadmap.dart';
import '../../../../repositories/roadmap_repository.dart';

part 'edit_action_resource_state.dart';

class EditActionResourceCubit extends Cubit<EditActionResourceState> {
  EditActionResourceCubit(this._roadmapRepository)
      : super(EditActionResourceInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> editResource(EditActionResourceInput input) async {
    try {
      emit(EditActionResourceLoading());
      final resource = await _roadmapRepository.updateActionResource(input);
      emit(EditActionResourceSuccess(resource: resource));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(EditActionResourceError(error: e));
    }
  }
}
