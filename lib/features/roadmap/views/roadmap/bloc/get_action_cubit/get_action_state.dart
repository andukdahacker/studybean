part of 'get_action_cubit.dart';

sealed class GetActionState extends Equatable {}

class GetActionInitial extends GetActionState {
  @override
  List<Object> get props => [];
}

class GetActionLoading extends GetActionState {
  @override
  List<Object> get props => [];
}

class GetActionSuccess extends GetActionState {
  final MilestoneAction action;

  GetActionSuccess(this.action);

  @override
  List<Object> get props => [action];
}

class GetActionError extends GetActionState {
  final Object error;

  GetActionError(this.error);

  @override
  List<Object> get props => [error];
}