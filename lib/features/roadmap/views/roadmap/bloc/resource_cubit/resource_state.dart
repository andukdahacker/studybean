part of 'resource_cubit.dart';

sealed class ResourceState extends Equatable {}

class ResourceInitial extends ResourceState {
  @override
  List<Object?> get props => [];
}

class ResourceLoading extends ResourceState {
  @override
  List<Object?> get props => [];
}

class ResourceLoaded extends ResourceState {
  final String filePath;

  ResourceLoaded({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class ResourceFailed extends ResourceState {
  final Object error;

  ResourceFailed(this.error);
  @override
  List<Object?> get props => [error];

}

