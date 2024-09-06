part of 'edit_local_action_cubit.dart';

sealed class EditLocalActionState extends Equatable {}

class EditLocalActionInitial extends EditLocalActionState {
  @override
  List<Object?> get props => [];
}

class EditLocalActionLoading extends EditLocalActionState {
  @override
  List<Object?> get props => [];
}

class EditLocalActionSuccess extends EditLocalActionState {
  final MilestoneAction action;

  EditLocalActionSuccess({required this.action});

  @override
  List<Object?> get props => [action];
}

class EditLocalActionError extends EditLocalActionState {
  @override
  List<Object?> get props => [];
}