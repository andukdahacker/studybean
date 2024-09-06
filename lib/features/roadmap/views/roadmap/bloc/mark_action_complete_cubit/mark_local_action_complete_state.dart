part of 'mark_local_action_complete_cubit.dart';

sealed class MarkLocalActionCompleteState extends Equatable {}

class MarkLocalActionCompleteInitial
    extends MarkLocalActionCompleteState {
  @override
  List<Object> get props => [];
}

class MarkLocalActionCompleteLoading
    extends MarkLocalActionCompleteState {
  @override
  List<Object> get props => [];
}

class MarkLocalActionCompleteSuccess
    extends MarkLocalActionCompleteState {
  final MilestoneAction action;

  MarkLocalActionCompleteSuccess({required this.action});
  @override
  List<Object> get props => [action];
}

class MarkLocalActionCompleteFailure
    extends MarkLocalActionCompleteState {
  @override
  List<Object> get props => [];
}



