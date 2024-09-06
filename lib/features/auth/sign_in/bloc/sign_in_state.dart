part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {}

class SignInInitial extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInLoading extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInFirebaseSuccess extends SignInState {
  final String token;

  SignInFirebaseSuccess({required this.token});
  @override
  List<Object?> get props => [token];
}

class SignInFirebaseError extends SignInState {
  final String message;

  SignInFirebaseError({required this.message});
  @override
  List<Object?> get props => [message];
}

class SignInSuccess extends SignInState {
  final User user;

  SignInSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignInError extends SignInState {
  final String message;

  SignInError({required this.message});

  @override
  List<Object?> get props => [message];
}