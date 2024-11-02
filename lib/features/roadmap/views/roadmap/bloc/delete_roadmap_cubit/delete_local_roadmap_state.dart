part of 'delete_local_roadmap_cubit.dart';

sealed class DeleteLocalRoadmapState extends Equatable {}

class DeleteLocalRoadmapInitial extends DeleteLocalRoadmapState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalRoadmapSuccess extends DeleteLocalRoadmapState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalRoadmapError extends DeleteLocalRoadmapState {
  final Object error;

  DeleteLocalRoadmapError(this.error);

  @override
  List<Object?> get props => [error];
}
