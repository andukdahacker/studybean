part of 'edit_action_resource_cubit.dart';

sealed class EditActionResourceState extends Equatable {}

class EditActionResourceInitial extends EditActionResourceState {
  @override
  List<Object?> get props => [];
}

class EditActionResourceLoading extends EditActionResourceState {
  @override
  List<Object?> get props => [];
}

class EditActionResourceSuccess extends EditActionResourceState {
  final ActionResource resource;

  EditActionResourceSuccess({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class EditActionResourceError extends EditActionResourceState {
  final Object error;

  EditActionResourceError({required this.error});
  @override
  List<Object?> get props => [error];
}