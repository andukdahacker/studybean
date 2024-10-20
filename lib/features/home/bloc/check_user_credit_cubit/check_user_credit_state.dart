part of 'check_user_credit_cubit.dart';

sealed class CheckUserCreditState extends Equatable {}

class CheckUserCreditInitial extends CheckUserCreditState {
  @override
  List<Object> get props => [];
}

class CheckUserCreditLoading extends CheckUserCreditState {
  @override
  List<Object> get props => [];
}

class CheckUserCreditSuccess extends CheckUserCreditState {
  final int totalCredits;

  CheckUserCreditSuccess({required this.totalCredits});

  @override
  List<Object> get props => [totalCredits];
}

class CheckUserCreditError extends CheckUserCreditState {
  final Object error;

  CheckUserCreditError(this.error);

  @override
  List<Object> get props => [error];
}