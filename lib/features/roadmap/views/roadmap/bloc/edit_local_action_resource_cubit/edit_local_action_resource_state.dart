part of 'edit_local_action_resource_cubit.dart';

sealed class EditLocalActionResourceState extends Equatable {}

class EditLocalActionResourceInitial extends EditLocalActionResourceState {
  @override
  List<Object?> get props => [];
}

class EditLocalActionResourceLoading extends EditLocalActionResourceState {
  @override
  List<Object?> get props => [];
}

class EditLocalActionResourceSuccess extends EditLocalActionResourceState {
  final ActionResource resource;

  EditLocalActionResourceSuccess({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class EditLocalActionResourceError extends EditLocalActionResourceState {
  @override
  List<Object?> get props => [];
}
