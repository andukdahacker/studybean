part of 'delete_local_action_cubit.dart';

sealed class DeleteLocalActionState extends Equatable {}

class DeleteLocalActionInitial extends DeleteLocalActionState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalActionLoading extends DeleteLocalActionState {
  @override
  List<Object?> get props => [];
}

class DeleteLocalActionSuccess extends DeleteLocalActionState {
  final String actionId;

  DeleteLocalActionSuccess({required this.actionId});

  @override
  List<Object?> get props => [actionId];
}

class DeleteLocalActionError extends DeleteLocalActionState {
  @override
  List<Object?> get props => [];
}