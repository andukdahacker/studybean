part of 'delete_action_cubit.dart';

sealed class DeleteActionState extends Equatable {}

class DeleteActionInitial extends DeleteActionState {
  @override
  List<Object> get props => [];
}

class DeleteActionLoading extends DeleteActionState {
  @override
  List<Object> get props => [];
}

class DeleteActionSuccess extends DeleteActionState {
  @override
  List<Object> get props => [];
}

class DeleteActionError extends DeleteActionState {
  final Object error;

  DeleteActionError(this.error);
  @override
  List<Object> get props => [error];
}