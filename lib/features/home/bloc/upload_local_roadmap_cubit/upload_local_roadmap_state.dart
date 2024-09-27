part of 'upload_local_roadmap_cubit.dart';

sealed class UploadLocalRoadmapState extends Equatable {}

class UploadLocalRoadmapInitial extends UploadLocalRoadmapState {
  @override
  List<Object> get props => [];
}

class UploadLocalRoadmapLoading extends UploadLocalRoadmapState {
  @override
  List<Object> get props => [];
}

class UploadLocalRoadmapSuccess extends UploadLocalRoadmapState {
  @override
  List<Object> get props => [];
}

class UploadLocalRoadmapError extends UploadLocalRoadmapState {
  final Object error;

  UploadLocalRoadmapError({required this.error});

  @override
  List<Object> get props => [error];
}