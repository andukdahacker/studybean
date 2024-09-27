part of 'change_password_cubit.dart';

sealed class ChangePasswordState extends Equatable {}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordLoading extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordSuccess extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordError extends ChangePasswordState {
  final Object error;

  ChangePasswordError({required this.error});
  @override
  List<Object> get props => [error];
}
