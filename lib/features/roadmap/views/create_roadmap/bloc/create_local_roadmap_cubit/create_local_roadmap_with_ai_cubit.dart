import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/services/shared_preference_service.dart';
import 'package:studybean/features/roadmap/models/generate_milestone_with_ai_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

import '../../../../models/create_local_roadmap_input.dart';
import '../../../../models/roadmap.dart';

part 'create_local_roadmap_with_ai_state.dart';

class CreateLocalRoadmapWithAiCubit
    extends Cubit<CreateLocalRoadmapWithAiState> {
  CreateLocalRoadmapWithAiCubit(
    this._roadmapRepository,
    this._roadmapLocalRepository,
    this._sharedPreferenceService,
  ) : super(CreateLocalRoadmapWithAiInitial());

  final RoadmapRepository _roadmapRepository;
  final RoadmapLocalRepository _roadmapLocalRepository;
  final SharedPreferenceService _sharedPreferenceService;

  Future<void> createLocalRoadmapWithAI(
      GenerateMilestoneWithAiInput input) async {
    try {
      emit(CreateLocalRoadmapWithAiLoading());
      final generatedMilestones =
          await _roadmapRepository.generateMilestoneWithAI(input);
      final roadmap = await _roadmapLocalRepository.createRoadmapWithAi(
          generatedMilestones,
          CreateLocalRoadmapInput(
              subject: input.subjectName, goal: input.goal));

      await _sharedPreferenceService.decrementCredits();
      emit(CreateLocalRoadmapWithAiSuccess(roadmap: roadmap));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      addError(e, stackTrace);
      emit(CreateLocalRoadmapWithAiError());
    }
  }
}
