part of 'choose_subject_cubit.dart';

sealed class ChooseSubjectState extends Equatable {
}

class ChooseSubjectInitial extends ChooseSubjectState {
  @override
  List<Object?> get props => [];
}

class ChooseSubjectLoading extends ChooseSubjectState {
  @override
  List<Object?> get props => [];
}

class ChooseSubjectLoaded extends ChooseSubjectState {
  final List<Subject> subjects;

  ChooseSubjectLoaded({
    required this.subjects
  });
  @override
  List<Object?> get props => [subjects];
}

class ChooseSubjectError extends ChooseSubjectState {
  @override
  List<Object?> get props => [];
}