import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/create_action_resource_input.dart';
import '../../../../models/roadmap.dart';
import '../../../../repositories/roadmap_repository.dart';

part 'create_action_resource_state.dart';

class CreateActionResourceCubit extends Cubit<CreateActionResourceState> {
  CreateActionResourceCubit(this._roadmapRepository) : super(CreateActionResourceInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> createResource(CreateActionResourceInput input) async {
    try {
      emit(CreateActionResourceLoading());
      final resource = await _roadmapRepository.createActionResource(input);
      emit(CreateActionResourceSuccess(resource: resource));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(CreateActionResourceError(error: e));
    }
  }
}