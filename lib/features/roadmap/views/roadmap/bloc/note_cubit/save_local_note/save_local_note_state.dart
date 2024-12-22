part of 'save_local_note_cubit.dart';

sealed class SaveLocalNoteState extends Equatable {}

class SaveLocalNoteInitial extends SaveLocalNoteState {
  @override
  List<Object?> get props => [];
}

class SaveLocalNoteLoading extends SaveLocalNoteState {
  @override
  List<Object?> get props => [];
}

class SaveLocalNoteSuccess extends SaveLocalNoteState {
  @override
  List<Object?> get props => [];
}

class SaveLocalNoteFailed extends SaveLocalNoteState {
  final Object error;

  SaveLocalNoteFailed(this.error);

  @override
  List<Object?> get props => [error];
}