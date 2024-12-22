part of 'parse_note_cubit.dart';

sealed class ParseNoteState extends Equatable {}

class ParseNoteInitial extends ParseNoteState {
  @override
  List<Object?> get props => [];
}

class ParseNoteLoading extends ParseNoteState {
  @override
  List<Object?> get props => [];
}

class ParseNoteSuccess extends ParseNoteState {
  final dynamic json;

  ParseNoteSuccess(this.json);

  @override
  List<Object?> get props => [json];
}

class ParseNoteFailed extends ParseNoteState {
  final Object error;

  ParseNoteFailed(this.error);

  @override
  List<Object?> get props => [error];
}

