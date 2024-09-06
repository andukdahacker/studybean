import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/create_local_action_resource_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../../repositories/roadmap_local_repository.dart';

part 'create_action_resource_state.dart';

class CreateLocalActionResourceCubit extends Cubit<CreateLocalActionResourceState> {
  CreateLocalActionResourceCubit(this._roadmapLocalRepository) : super(CreateLocalActionResourceInitial());

  final RoadmapLocalRepository _roadmapLocalRepository;

  Future<void> createResource(CreateLocalActionResourceInput input) async {
    try {
      emit(CreateLocalActionResourceLoading());
      final resource = await _roadmapLocalRepository.createActionResource(input);
      emit(CreateLocalActionResourceSuccess(resource: resource));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(CreateLocalActionResourceError());
    }
  }
}