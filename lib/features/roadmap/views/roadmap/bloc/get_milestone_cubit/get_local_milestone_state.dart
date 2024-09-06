part of 'get_local_milestone_cubit.dart';

sealed class GetLocalMilestoneState extends Equatable {}

class GetLocalMilestoneInitial extends GetLocalMilestoneState {
  @override
  List<Object?> get props => [];
}

class GetLocalMilestoneLoading extends GetLocalMilestoneState {
  @override
  List<Object?> get props => [];
}

class GetLocalMilestoneSuccess extends GetLocalMilestoneState {
  final Milestone milestone;
  GetLocalMilestoneSuccess({required this.milestone});

  @override
  List<Object?> get props => [milestone];
}

class GetLocalMilestoneError extends GetLocalMilestoneState {
  @override
  List<Object?> get props => [];
}