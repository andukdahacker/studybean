part of 'delete_local_action_resource_cubit.dart';

sealed class DeleteLocalActionResourceState extends Equatable {}

class DeleteLocalActionResourceInitial extends DeleteLocalActionResourceState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalActionResourceLoading extends DeleteLocalActionResourceState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalActionResourceSuccess extends DeleteLocalActionResourceState {
  final String resourceId;

  DeleteLocalActionResourceSuccess({required this.resourceId});

  @override
  List<Object?> get props => [resourceId];
}

class DeleteLocalActionResourceError extends DeleteLocalActionResourceState {
  @override
  List<Object?> get props => [];
}

