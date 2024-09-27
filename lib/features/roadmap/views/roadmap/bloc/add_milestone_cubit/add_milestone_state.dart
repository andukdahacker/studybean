part of 'add_milestone_cubit.dart';

sealed class AddMilestoneState extends Equatable {}

class AddMilestoneInitial extends AddMilestoneState {
  @override
  List<Object?> get props => [];
}

class AddMilestoneLoading extends AddMilestoneState {
  @override
  List<Object?> get props => [];
}

class AddMilestoneSuccess extends AddMilestoneState {
  final Milestone milestone;

  AddMilestoneSuccess(this.milestone);
  @override
  List<Object?> get props => [milestone];
}

class AddMilestoneError extends AddMilestoneState {
  @override
  List<Object?> get props => [];
}

