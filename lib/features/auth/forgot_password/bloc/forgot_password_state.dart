part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState extends Equatable {}

class ForgotPasswordInitial extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordLoading extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordError extends ForgotPasswordState {
  final Object error;

  ForgotPasswordError({required this.error});

  @override
  List<Object> get props => [error];
}