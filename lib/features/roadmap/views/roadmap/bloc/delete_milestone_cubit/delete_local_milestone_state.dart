part of 'delete_local_milestone_cubit.dart';

sealed class DeleteLocalMilestoneState extends Equatable {}

class DeleteLocalMilestoneInitial extends DeleteLocalMilestoneState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalMilestoneLoading extends DeleteLocalMilestoneState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalMilestoneSuccess extends DeleteLocalMilestoneState {
  final String milestoneId;

  DeleteLocalMilestoneSuccess({required this.milestoneId});

  @override
  List<Object?> get props => [milestoneId];
}

class DeleteLocalMilestoneError extends DeleteLocalMilestoneState {
  @override
  List<Object?> get props => [];
}