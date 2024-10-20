part of 'delete_roadmap_cubit.dart';

sealed class DeleteRoadmapState extends Equatable {}

class DeleteRoadmapInitial extends DeleteRoadmapState {
  @override
  List<Object> get props => [];
}

class DeleteRoadmapLoading extends DeleteRoadmapState {
  @override
  List<Object> get props => [];
}

class DeleteRoadmapSuccess extends DeleteRoadmapState {
  @override
  List<Object> get props => [];
}

class DeleteRoadmapError extends DeleteRoadmapState {
  final Object error;

  DeleteRoadmapError({required this.error});

  @override
  List<Object> get props => [error];
}