import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/services/shared_preference_service.dart';

part 'save_local_note_state.dart';

class SaveLocalNoteCubit extends Cubit<SaveLocalNoteState> {
  SaveLocalNoteCubit(this._sharedPreferenceService) : super(SaveLocalNoteInitial());

  final SharedPreferenceService _sharedPreferenceService;

  Future<void> saveToLocal(String resourceId) async {
    try {

    } catch(e, stackTrace) {
      addError(e, stackTrace);
    }
  }

}