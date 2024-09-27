part of 'create_roadmap_with_ai_cubit.dart';

sealed class CreateRoadmapWithAiState extends Equatable {}

class CreateRoadmapWithAiInitial extends CreateRoadmapWithAiState {
  @override
  List<Object> get props => [];
}


class CreateRoadmapWithAiLoading extends CreateRoadmapWithAiState {
  @override
  List<Object> get props => [];
}


class CreateRoadmapWithAiSuccess extends CreateRoadmapWithAiState {
  final Roadmap roadmap;
  CreateRoadmapWithAiSuccess(this.roadmap);
  @override
  List<Object> get props => [roadmap];
}

class CreateRoadmapWithAiError extends CreateRoadmapWithAiState {
  @override
  List<Object> get props => [];
}