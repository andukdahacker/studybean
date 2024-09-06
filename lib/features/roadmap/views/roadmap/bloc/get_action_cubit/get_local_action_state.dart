part of 'get_local_action_cubit.dart';

sealed class GetLocalActionState extends Equatable {}

class GetLocalActionInitial extends GetLocalActionState {
  @override
  List<Object> get props => [];
}

class GetLocalActionLoading extends GetLocalActionState {
  @override
  List<Object> get props => [];
}

class GetLocalActionSuccess extends GetLocalActionState {
  final MilestoneAction action;
  GetLocalActionSuccess({required this.action});
  @override
  List<Object> get props => [action];
}

class GetLocalActionError extends GetLocalActionState {
  @override
  List<Object> get props => [];
}