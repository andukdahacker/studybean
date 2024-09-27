part of 'edit_action_cubit.dart';

sealed class EditActionState extends Equatable {}

class EditActionInitial extends EditActionState {
  @override
  List<Object> get props => [];
}

class EditActionLoading extends EditActionState {
  @override
  List<Object> get props => [];
}

class EditActionSuccess extends EditActionState {
  final MilestoneAction action;

  EditActionSuccess(this.action);
  @override
  List<Object> get props => [action];
}

class EditActionError extends EditActionState {
  final Object error;

  EditActionError(this.error);
  @override
  List<Object> get props => [error];
}