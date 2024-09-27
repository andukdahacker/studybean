part of 'get_milestone_cubit.dart';

sealed class GetMilestoneState extends Equatable {}

class GetMilestoneInitial extends GetMilestoneState {
  @override
  List<Object?> get props => [];
}

class GetMilestoneLoading extends GetMilestoneState {
  @override
  List<Object?> get props => [];
}

class GetMilestoneSuccess extends GetMilestoneState {
  final Milestone milestone;

  GetMilestoneSuccess({required this.milestone});

  @override
  List<Object?> get props => [milestone];
}

class GetMilestoneError extends GetMilestoneState {
  @override
  List<Object?> get props => [];
}
