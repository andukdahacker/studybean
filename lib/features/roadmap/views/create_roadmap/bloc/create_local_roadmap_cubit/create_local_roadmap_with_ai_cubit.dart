import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/generate_milestone_with_ai_input.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_local_repository.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';
import 'package:studybean/features/roadmap/repositories/user_local_repository.dart';

import '../../../../models/create_local_roadmap_input.dart';
import '../../../../models/roadmap.dart';

part 'create_local_roadmap_with_ai_state.dart';

class CreateLocalRoadmapWithAiCubit
    extends Cubit<CreateLocalRoadmapWithAiState> {
  CreateLocalRoadmapWithAiCubit(
    this._roadmapRepository,
    this._roadmapLocalRepository,
    this._userLocalRepository,
  ) : super(CreateLocalRoadmapWithAiInitial());

  final RoadmapRepository _roadmapRepository;
  final RoadmapLocalRepository _roadmapLocalRepository;
  final UserLocalRepository _userLocalRepository;

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
      await _userLocalRepository.decreaseCredits();
      emit(CreateLocalRoadmapWithAiSuccess(roadmap: roadmap));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      addError(e, stackTrace);
      emit(CreateLocalRoadmapWithAiError());
    }
  }
}
