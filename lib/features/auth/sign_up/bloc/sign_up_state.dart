part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {}

class SignUpInitial extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpLoading extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpFirebaseSuccess extends SignUpState {
  final firebase_auth.UserCredential userCredential;

  SignUpFirebaseSuccess({required this.userCredential});

  @override
  List<Object?> get props => [userCredential];
}

class SignUpFirebaseError extends SignUpState {
  final String message;

  SignUpFirebaseError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SignUpSuccess extends SignUpState {
  final User user;
  final bool isEmailVerified;

  SignUpSuccess({required this.user, required this.isEmailVerified});

  @override
  List<Object?> get props => [user, isEmailVerified];
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError({required this.message});

  @override
  List<Object?> get props => [message];
}
