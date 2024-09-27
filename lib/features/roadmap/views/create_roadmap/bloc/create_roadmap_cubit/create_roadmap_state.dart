part of 'create_roadmap_cubit.dart';

sealed class CreateRoadmapState extends Equatable {}

class CreateRoadmapInitial extends CreateRoadmapState {
  @override
  List<Object?> get props => [];
}

class CreateRoadmapLoading extends CreateRoadmapState {
  @override
  List<Object?> get props => [];
}

class CreateRoadmapSuccess extends CreateRoadmapState {
  final Roadmap roadmap;
  CreateRoadmapSuccess(this.roadmap);
  @override
  List<Object?> get props => [roadmap];
}

class CreateRoadmapError extends CreateRoadmapState {
  @override
  List<Object?> get props => [];
}