import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/services/shared_preference_service.dart';

part 'check_local_user_credit_state.dart';

class CheckLocalUserCreditCubit extends Cubit<CheckLocalUserCreditState> {
  CheckLocalUserCreditCubit(this._sharedPreferenceService)
      : super(CheckLocalUserCreditInitial());

  final SharedPreferenceService _sharedPreferenceService;

  Future<void> checkUserCredit() async {
    try {
      emit(CheckLocalUserCreditLoading());
      final credits = _sharedPreferenceService.getCredits();

      emit(CheckLocalUserCreditSuccess(totalCredits: credits));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(CheckLocalUserCreditError(e));
    }
  }
}
