part of 'create_action_resource_cubit.dart';

sealed class CreateLocalActionResourceState extends Equatable {}

class CreateLocalActionResourceInitial extends CreateLocalActionResourceState {
  @override
  List<Object?> get props => [];
}

class CreateLocalActionResourceLoading extends CreateLocalActionResourceState {
  @override
  List<Object?> get props => [];
}

class CreateLocalActionResourceSuccess extends CreateLocalActionResourceState {
  final ActionResource resource;

  CreateLocalActionResourceSuccess({required this.resource});
  @override
  List<Object?> get props => [resource];
}

class CreateLocalActionResourceError extends CreateLocalActionResourceState {
  @override
  List<Object?> get props => [];
}