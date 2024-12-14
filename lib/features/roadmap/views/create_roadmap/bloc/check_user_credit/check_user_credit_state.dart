part of 'check_user_credit_cubit.dart';

sealed class CheckUserCreditState extends Equatable {}

class CheckUserCreditInitial extends CheckUserCreditState {
  @override
  List<Object?> get props => [];
}

class CheckUserCreditLoading extends CheckUserCreditState {
  @override
  List<Object?> get props => [];
}

class CheckUserCreditLoaded extends CheckUserCreditState {
  @override
  List<Object?> get props => [];
}

class CheckUserCreditError extends CheckUserCreditState {
  @override
  List<Object?> get props => [];
}

