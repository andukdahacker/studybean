part of 'check_local_user_credit_cubit.dart';

sealed class CheckLocalUserCreditState extends Equatable {}

class CheckLocalUserCreditInitial extends CheckLocalUserCreditState {
  @override
  List<Object> get props => [];
}

class CheckLocalUserCreditLoading extends CheckLocalUserCreditState {
  @override
  List<Object> get props => [];
}

class CheckLocalUserCreditSuccess extends CheckLocalUserCreditState {
  final int totalCredits;

  CheckLocalUserCreditSuccess({required this.totalCredits});

  @override
  List<Object> get props => [totalCredits];
}

class CheckLocalUserCreditError extends CheckLocalUserCreditState {
  final Object error;

  CheckLocalUserCreditError(this.error);

  @override
  List<Object> get props => [error];
}