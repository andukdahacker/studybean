part of 'delete_action_resource_cubit.dart';

sealed class DeleteActionResourceState extends Equatable {}

class DeleteActionResourceInitial extends DeleteActionResourceState {
  @override
  List<Object?> get props => [];
}

class DeleteActionResourceLoading extends DeleteActionResourceState {
  @override
  List<Object?> get props => [];
}

class DeleteActionResourceSuccess extends DeleteActionResourceState {
  final String id;


  DeleteActionResourceSuccess({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeleteActionResourceError extends DeleteActionResourceState {
  final Object error;

  DeleteActionResourceError({required this.error});
  @override
  List<Object?> get props => [error];
}