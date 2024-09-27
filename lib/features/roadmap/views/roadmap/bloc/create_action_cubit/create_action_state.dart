part of 'create_action_cubit.dart';

sealed class CreateActionState extends Equatable {}

class CreateActionInitial extends CreateActionState {
  @override
  List<Object?> get props => [];
}

class CreateActionLoading extends CreateActionState {
  @override
  List<Object?> get props => [];
}

class CreateActionSuccess extends CreateActionState {
  final MilestoneAction action;
  CreateActionSuccess(this.action);
  @override
  List<Object?> get props => [action];
}

class CreateActionError extends CreateActionState {
  final Object error;

  CreateActionError(this.error);
  @override
  List<Object?> get props => [error];
}