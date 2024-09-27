part of 'get_roadmap_detail_cubit.dart';

sealed class GetRoadmapDetailState extends Equatable {}

class GetRoadmapDetailInitial extends GetRoadmapDetailState {
  @override
  List<Object?> get props => [];
}

class GetRoadmapDetailLoading extends GetRoadmapDetailState {
  @override
  List<Object?> get props => [];
}

class GetRoadmapDetailSuccess extends GetRoadmapDetailState {
  final Roadmap roadmap;
  GetRoadmapDetailSuccess(this.roadmap);
  @override
  List<Object?> get props => [roadmap];
}

class GetRoadmapDetailError extends GetRoadmapDetailState {
  @override
  List<Object?> get props => [];
}