import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/subject_repository.dart';

import '../../../../models/subject.dart';

part 'create_subject_state.dart';

class CreateSubjectCubit extends Cubit<CreateSubjectState> {
  CreateSubjectCubit(this._subjectRepository) : super(CreateSubjectInitial());

  final SubjectRepository _subjectRepository;

  Future<void> createSubject(String name) async {
    try {
      emit(CreateSubjectLoading());
      final subject = await _subjectRepository.createSubject(name);
      emit(CreateSubjectSuccess(subject));
    } catch(e, stackTrace) {
      addError(e, stackTrace);
      emit(CreateSubjectError(e.toString()));
    }
  }
}