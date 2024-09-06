part of 'add_local_milestone_cubit.dart';

sealed class AddLocalMilestoneState extends Equatable {}

class AddLocalMilestoneInitial extends AddLocalMilestoneState {
  @override
  List<Object> get props => [];
}

class AddLocalMilestoneLoading extends AddLocalMilestoneState {
  @override
  List<Object> get props => [];
}

class AddLocalMilestoneSuccess extends AddLocalMilestoneState {
  final Milestone milestone;

  AddLocalMilestoneSuccess({required this.milestone});

  @override
  List<Object> get props => [milestone];
}

class AddLocalMilestoneError extends AddLocalMilestoneState {
  @override
  List<Object> get props => [];
}

