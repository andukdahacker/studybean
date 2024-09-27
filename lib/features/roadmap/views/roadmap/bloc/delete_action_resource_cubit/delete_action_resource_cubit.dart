import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repositories/roadmap_repository.dart';

part 'delete_action_resource_state.dart';

class DeleteActionResourceCubit extends Cubit<DeleteActionResourceState> {
  DeleteActionResourceCubit(this._roadmapRepository)
      : super(DeleteActionResourceInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> deleteResource(String id) async {
    try {
      emit(DeleteActionResourceLoading());
      await _roadmapRepository.deleteResource(id);
      emit(DeleteActionResourceSuccess(id: id));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(DeleteActionResourceError(error: e));
    }
  }
}