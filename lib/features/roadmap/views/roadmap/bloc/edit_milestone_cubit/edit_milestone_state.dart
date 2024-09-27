part of 'edit_milestone_cubit.dart';

sealed class EditMilestoneState extends Equatable {}

class EditMilestoneInitial extends EditMilestoneState {
  @override
  List<Object?> get props => [];
}

class EditMilestoneLoading extends EditMilestoneState {
  @override
  List<Object?> get props => [];
}

class EditMilestoneSuccess extends EditMilestoneState {
  final Milestone milestone;

  EditMilestoneSuccess({required this.milestone});

  @override
  List<Object?> get props => [milestone];
}

class EditMilestoneError extends EditMilestoneState {
  final Object error;

  EditMilestoneError({required this.error});
  @override
  List<Object?> get props => [error];
}