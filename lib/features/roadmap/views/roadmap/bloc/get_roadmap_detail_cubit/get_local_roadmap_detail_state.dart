part of 'get_local_roadmap_detail_cubit.dart';

sealed class GetLocalRoadmapDetailState extends Equatable {}

class GetLocalRoadmapDetailInitial extends GetLocalRoadmapDetailState {
  @override
  List<Object> get props => [];
}

class GetLocalRoadmapDetailLoading extends GetLocalRoadmapDetailState {
  @override
  List<Object> get props => [];
}

class GetLocalRoadmapDetailSuccess extends GetLocalRoadmapDetailState {
  final Roadmap roadmap;

  GetLocalRoadmapDetailSuccess(this.roadmap);

  @override
  List<Object> get props => [roadmap];
}

class GetLocalRoadmapDetailError extends GetLocalRoadmapDetailState {
  @override
  List<Object> get props => [];
}