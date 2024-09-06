part of 'get_local_roadmap_cubit.dart';

sealed class GetLocalRoadmapState extends Equatable {}

class GetLocalRoadmapInitial extends GetLocalRoadmapState {
  @override
  List<Object?> get props => [];
}

class GetLocalRoadmapLoading extends GetLocalRoadmapState {
  @override
  List<Object?> get props => [];
}

class GetLocalRoadmapSuccess extends GetLocalRoadmapState {
  final List<Roadmap> roadmaps;
  GetLocalRoadmapSuccess(this.roadmaps);
  @override
  List<Object?> get props => [roadmaps];
}

class GetLocalRoadmapError extends GetLocalRoadmapState {
  @override
  List<Object?> get props => [];
}