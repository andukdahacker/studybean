import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

import '../../../../models/create_roadmap_input.dart';
import '../../../../models/roadmap.dart';

part 'create_roadmap_with_ai_state.dart';

class CreateRoadmapWithAiCubit extends Cubit<CreateRoadmapWithAiState> {
  CreateRoadmapWithAiCubit(this._roadmapRepository) : super(CreateRoadmapWithAiInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> createRoadmapWithAI(CreateRoadmapInput input) async {
    try {
      emit(CreateRoadmapWithAiLoading());
      final response = await _roadmapRepository.createRoadmapWithAI(input);
      emit(CreateRoadmapWithAiSuccess(response));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(CreateRoadmapWithAiError());
    }
  }
}