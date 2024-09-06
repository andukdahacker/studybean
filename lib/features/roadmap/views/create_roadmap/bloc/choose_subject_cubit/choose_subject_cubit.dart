import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/subject_repository.dart';

import '../../../../models/get_many_subject_input.dart';
import '../../../../models/subject.dart';

part 'choose_subject_state.dart';

class ChooseSubjectCubit extends Cubit<ChooseSubjectState> {
  ChooseSubjectCubit(this._subjectRepository) : super(ChooseSubjectInitial());

  final SubjectRepository _subjectRepository;

  Future<void> getSubjects(String name) async {
    try {
      emit(ChooseSubjectLoading());

      final response = await _subjectRepository.getSubjects(GetManySubjectInput(
        name: name,
        take: 20,
        cursor: null,
      ));

      final subjects = response.nodes;

      emit(ChooseSubjectLoaded(subjects: subjects));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      emit(ChooseSubjectError());
    }
  }
}