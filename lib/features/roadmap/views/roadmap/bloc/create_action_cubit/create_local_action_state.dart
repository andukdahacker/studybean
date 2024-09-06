part of 'create_local_action_cubit.dart';

sealed class CreateLocalActionState extends Equatable {}

class CreateLocalActionInitial extends CreateLocalActionState {
  @override
  List<Object?> get props => [];
}

class CreateLocalActionLoading extends CreateLocalActionState {
  @override
  List<Object?> get props => [];
}

class CreateLocalActionSuccess extends CreateLocalActionState {
  final MilestoneAction action;

  CreateLocalActionSuccess({required this.action});

  @override
  List<Object?> get props => [action];
}

class CreateLocalActionError extends CreateLocalActionState {
  @override
  List<Object?> get props => [];
}