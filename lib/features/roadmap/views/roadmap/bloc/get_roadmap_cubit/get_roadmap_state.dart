part of 'get_roadmap_cubit.dart';

sealed class GetRoadmapState extends Equatable {}

class GetRoadmapInitial extends GetRoadmapState {
  @override
  List<Object?> get props => [];
}

class GetRoadmapLoading extends GetRoadmapState {
  @override
  List<Object?> get props => [];
}

class GetRoadmapSuccess extends GetRoadmapState {
  final List<Roadmap> roadmaps;

  GetRoadmapSuccess(this.roadmaps);

  @override
  List<Object?> get props => [roadmaps];
}

class GetRoadmapError extends GetRoadmapState {
  @override
  List<Object?> get props => [];
}