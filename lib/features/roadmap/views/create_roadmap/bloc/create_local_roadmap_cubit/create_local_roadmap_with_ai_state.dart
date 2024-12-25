part of 'create_local_roadmap_with_ai_cubit.dart';

sealed class CreateLocalRoadmapWithAiState extends Equatable {}

class CreateLocalRoadmapWithAiInitial
    extends CreateLocalRoadmapWithAiState {
  @override
  List<Object?> get props => [];
}

class CreateLocalRoadmapWithAiLoading
    extends CreateLocalRoadmapWithAiState {
  @override
  List<Object?> get props => [];
}

class CreateLocalRoadmapWithAiSuccess
    extends CreateLocalRoadmapWithAiState {
  final Roadmap roadmap;

  CreateLocalRoadmapWithAiSuccess({required this.roadmap});

  @override
  List<Object?> get props => [roadmap];
}

class CreateLocalRoadmapWithAiError
    extends CreateLocalRoadmapWithAiState {
  final Object error;

  CreateLocalRoadmapWithAiError(this.error);
  @override
  List<Object?> get props => [error];
}