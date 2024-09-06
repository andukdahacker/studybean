part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashLoading extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashFirstTime extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashLoaded extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashError extends SplashState {
  final Object error;

  SplashError(this.error);

  @override
  List<Object> get props => [error];
}
