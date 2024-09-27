part of 'mark_action_complete_cubit.dart';

sealed class MarkActionCompleteState extends Equatable {}

class MarkActionCompleteInitial extends MarkActionCompleteState {
  @override
  List<Object> get props => [];
}

class MarkActionCompleteLoading extends MarkActionCompleteState {
  @override
  List<Object> get props => [];
}

class MarkActionCompleteSuccess extends MarkActionCompleteState {
  final MilestoneAction action;

  MarkActionCompleteSuccess(this.action);

  @override
  List<Object> get props => [action];
}

class MarkActionCompleteFailure extends MarkActionCompleteState {
  @override
  List<Object> get props => [];
}