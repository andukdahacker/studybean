part of 'create_subject_cubit.dart';

sealed class CreateSubjectState extends Equatable {}

class CreateSubjectInitial extends CreateSubjectState {
  @override
  List<Object?> get props => [];
}

class CreateSubjectLoading extends CreateSubjectState {
  @override
  List<Object?> get props => [];
}

class CreateSubjectSuccess extends CreateSubjectState {
  final Subject subject;

  CreateSubjectSuccess(this.subject);

  @override
  List<Object?> get props => [subject];
}

class CreateSubjectError extends CreateSubjectState {
  final String message;

  CreateSubjectError(this.message);

  @override
  List<Object?> get props => [message];
}
