import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/home/repository/home_repository.dart';

part 'check_user_credit_state.dart';

class CheckUserCreditCubit extends Cubit<CheckUserCreditState> {
  CheckUserCreditCubit(this._homeRepository) : super(CheckUserCreditInitial());

  final HomeRepository _homeRepository;

  Future<void> checkUserCredit() async {
    try {
      emit(CheckUserCreditLoading());
      final credits = await _homeRepository.getTotalCredits();
      emit(CheckUserCreditSuccess(totalCredits: credits));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(CheckUserCreditError(e));
    }
  }
}