import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/create_roadmap_input.dart';

import '../../../../models/roadmap.dart';
import '../../../../repositories/roadmap_repository.dart';

part 'create_roadmap_state.dart';

class CreateRoadmapCubit extends Cubit<CreateRoadmapState> {
  CreateRoadmapCubit(this._roadmapRepository) : super(CreateRoadmapInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> createRoadmap(CreateRoadmapInput input) async {
   try {
      emit(CreateRoadmapLoading());
      final response = await _roadmapRepository.createRoadmap(input);
      emit(CreateRoadmapSuccess(response));
   } catch(e, stackTrace) {
     addError(e, stackTrace);
     emit(CreateRoadmapError());
   }
  }
}