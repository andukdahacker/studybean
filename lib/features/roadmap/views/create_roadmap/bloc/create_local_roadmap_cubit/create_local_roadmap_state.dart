part of 'create_local_roadmap_cubit.dart';

sealed class CreateLocalRoadmapState extends Equatable {}

class CreateLocalRoadmapInitial extends CreateLocalRoadmapState {
  @override
  List<Object?> get props => [];
}

class CreateLocalRoadmapLoading extends CreateLocalRoadmapState {
  @override
  List<Object?> get props => [];
}

class CreateLocalRoadmapSuccess extends CreateLocalRoadmapState {
  final Roadmap roadmap;
  CreateLocalRoadmapSuccess(this.roadmap);
  @override
  List<Object?> get props => [roadmap];
}

class CreateLocalRoadmapError extends CreateLocalRoadmapState {
  @override
  List<Object?> get props => [];
}