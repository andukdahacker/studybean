import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'parse_note_state.dart';

class ParseNoteCubit extends Cubit<ParseNoteState> {
  ParseNoteCubit() : super(ParseNoteInitial());

  Future<void> parseNote(String? note) async {
    try {
      if(note == null || note.isEmpty) {
        emit(ParseNoteSuccess(null));
        return;
      }

      emit(ParseNoteLoading());
      final json = await compute(jsonDecode, note);

      emit(ParseNoteSuccess(json));
    } catch(e, stackTrace)  {
      addError(e, stackTrace);
      emit(ParseNoteFailed(e));
    }
  }
}