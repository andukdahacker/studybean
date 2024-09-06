part of 'edit_local_milestone_cubit.dart';

sealed class EditLocalMilestoneState extends Equatable {}

class EditLocalMilestoneInitial extends EditLocalMilestoneState {
  @override
  List<Object> get props => [];
}

class EditLocalMilestoneLoading extends EditLocalMilestoneState {
  @override
  List<Object> get props => [];
}

class EditLocalMilestoneSuccess extends EditLocalMilestoneState {

  final Milestone milestone;

  EditLocalMilestoneSuccess(this.milestone);

  @override
  List<Object> get props => [milestone];
}

class EditLocalMilestoneError extends EditLocalMilestoneState {
  @override
  List<Object> get props => [];
}