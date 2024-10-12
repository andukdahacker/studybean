import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/user_local_repository.dart';

part 'check_local_user_credit_state.dart';

class CheckLocalUserCreditCubit extends Cubit<CheckLocalUserCreditState> {
  CheckLocalUserCreditCubit(this._userLocalRepository)
      : super(CheckLocalUserCreditInitial());

  final UserLocalRepository _userLocalRepository;

  Future<void> checkUserCredit() async {
    try {
      emit(CheckLocalUserCreditLoading());
      final user = await _userLocalRepository.getUser();

      if (user == null) {
        emit(CheckLocalUserCreditError(Exception('User not found')));
        return;
      }

      emit(CheckLocalUserCreditSuccess(totalCredits: user.credits));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(CheckLocalUserCreditError(e));
    }
  }
}