part of 'create_action_resource_cubit.dart';

sealed class CreateActionResourceState extends Equatable {}

class CreateActionResourceInitial extends CreateActionResourceState {
  @override
  List<Object?> get props => [];
}

class CreateActionResourceLoading extends CreateActionResourceState {
  @override
  List<Object?> get props => [];
}

class CreateActionResourceSuccess extends CreateActionResourceState {
  final ActionResource resource;

  CreateActionResourceSuccess({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class CreateActionResourceError extends CreateActionResourceState {
  final Object error;

  CreateActionResourceError({required this.error});
  @override
  List<Object?> get props => [error];
}