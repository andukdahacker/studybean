import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'save_note_state.dart';

class SaveNoteCubit extends Cubit<SaveNoteState> {
  SaveNoteCubit(this._roadmapRepository) : super(SaveNoteInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> saveNote(String resourceId, String note) async {
    try {
      if (state is SaveNoteLoading) {
        return;
      }

      emit(SaveNoteLoading());

      final resource =
          await _roadmapRepository.updateResourceNotes(resourceId, note);

      emit(SaveNoteSuccess(resource));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(SaveNoteFailed(e));
    }
  }
}
