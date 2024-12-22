part of 'save_note_cubit.dart';

sealed class SaveNoteState extends Equatable {}

class SaveNoteInitial extends SaveNoteState {
  @override
  List<Object?> get props => [];
}

class SaveNoteLoading extends SaveNoteState {
  @override
  List<Object?> get props => [];
}

class SaveNoteSuccess extends SaveNoteState {
  final ActionResource actionResource;

  SaveNoteSuccess(this.actionResource);
  @override
  List<Object?> get props => [actionResource];
}

class SaveNoteFailed extends SaveNoteState {
  final Object error;

  SaveNoteFailed(this.error);

  @override
  List<Object?> get props => [error];
}